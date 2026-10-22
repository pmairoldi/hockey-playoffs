#!/usr/bin/env swift
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

// Usage: swift scripts/compare-screenshots.swift ORIGINAL CANDIDATE OUTPUT
// No third-party dependencies. Compare app content below the status bar, retaining
// the full images for review. Video playback is reported but is nondeterministic.
struct Image {
    let width: Int
    let height: Int
    var bytes: [UInt8]
    init(url: URL) throws {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
            let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            throw NSError(
                domain: "Screenshot", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot read \(url.path)"])
        }
        width = image.width
        height = image.height
        bytes = [UInt8](repeating: 0, count: width * height * 4)
        bytes.withUnsafeMutableBytes { buffer in
            let context = CGContext(
                data: buffer.baseAddress, width: width, height: height, bitsPerComponent: 8,
                bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
    }
    func write(to url: URL) {
        bytes.withUnsafeBytes { buffer in
            let provider = CGDataProvider(data: Data(buffer) as CFData)!
            let image = CGImage(
                width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32,
                bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
            let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
            CGImageDestinationAddImage(destination, image, nil)
            CGImageDestinationFinalize(destination)
        }
    }
}

guard CommandLine.arguments.count == 4 else {
    print("Usage: swift scripts/compare-screenshots.swift ORIGINAL CANDIDATE OUTPUT")
    exit(1)
}
let original = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
let candidate = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: true)
let output = URL(fileURLWithPath: CommandLine.arguments[3], isDirectory: true)
let files = try FileManager.default.contentsOfDirectory(atPath: original.path).filter { $0.hasSuffix(".png") }.sorted()
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
var rows: [[String: Any]] = []
var sections = ""
for file in files {
    let a = try Image(url: original.appendingPathComponent(file))
    let b = try Image(url: candidate.appendingPathComponent(file))
    guard a.width == b.width, a.height == b.height else { fatalError("Different screenshot dimensions: \(file)") }
    var difference = a
    var changed = 0
    var total = 0
    var absoluteError = 0
    // UIKit status-bar coordinates are not application layout. At 3x this is 60 pt.
    let statusBarPixels = Int(Double(a.width) / 402 * 60)
    for y in 0..<a.height {
        for x in 0..<a.width {
            let index = (y * a.width + x) * 4
            var largest = 0
            for channel in 0..<3 {
                let delta = abs(Int(a.bytes[index + channel]) - Int(b.bytes[index + channel]))
                largest = max(largest, delta)
                difference.bytes[index + channel] = UInt8(min(255, delta * 4))
                if y >= statusBarPixels { absoluteError += delta }
            }
            difference.bytes[index + 3] = 255
            if y >= statusBarPixels {
                total += 1
                if largest > 8 { changed += 1 }
            }
        }
    }
    let percentage = Double(changed) / Double(total) * 100
    let meanError = Double(absoluteError) / Double(total * 3)
    difference.write(to: output.appendingPathComponent("diff-" + file))
    for (prefix, directory) in [("original-", original), ("swift-", candidate)] {
        let target = output.appendingPathComponent(prefix + file)
        if FileManager.default.fileExists(atPath: target.path) { try FileManager.default.removeItem(at: target) }
        try FileManager.default.copyItem(at: directory.appendingPathComponent(file), to: target)
    }
    rows.append([
        "screen": file, "changedPercent": percentage, "meanChannelError": meanError,
        "nondeterministic": file.contains("Video"),
    ])
    let metric = String(format: "%.3f%% pixels differ by >8/255; mean channel error %.3f/255", percentage, meanError)
    print("\(file): \(metric)")
    sections +=
        "<section><h2>\(file.replacingOccurrences(of: "Review-", with: "").replacingOccurrences(of: "-Screen0.png", with: ""))</h2><p>\(metric)\(file.contains("Video") ? " — playback is nondeterministic" : "")</p><div class='images'><figure><figcaption>Original</figcaption><img src='original-\(file)'></figure><figure><figcaption>Swift / Auto Layout</figcaption><img src='swift-\(file)'></figure><figure><figcaption>Difference ×4</figcaption><img src='diff-\(file)'></figure></div></section>"
}
let report = try JSONSerialization.data(withJSONObject: rows, options: [.prettyPrinted, .sortedKeys])
try report.write(to: output.appendingPathComponent("metrics.json"))
let html = """
    <!doctype html><meta charset="utf-8"><title>Swift migration — visual comparison</title>
    <style>body{font:15px system-ui;background:#17191c;color:#eee;margin:30px}h1{font-size:28px}h2{font-size:19px}p{color:#adb6c2}.images{display:flex;gap:16px}figure{margin:0;flex:1;min-width:0}img{width:100%;height:auto}figcaption{margin:8px 0;color:#adb6c2}section{margin:40px 0;max-width:1400px}a{color:#79baff}</style>
    <h1>Swift / Auto Layout — before and after</h1><p>Same simulator, data, appearance and navigation. The status bar is excluded from metrics; video and translucent system materials may vary between captures.</p>\(sections)
    """
try html.write(to: output.appendingPathComponent("index.html"), atomically: true, encoding: .utf8)
