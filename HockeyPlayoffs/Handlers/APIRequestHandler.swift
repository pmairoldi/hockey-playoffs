import Foundation
import UIKit

@MainActor
final class APIRequestHandler {
    static let shared = APIRequestHandler()
    private let session: URLSession
    private let baseURL: URL
    private var timer: Timer?
    private var refreshTask: Task<Bool, Never>?

    private init() {
        guard let url = URL(string: Environment.apiBaseUrl) else { fatalError("Invalid API_BASE_URL") }
        baseURL = url
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 20
        let info = Bundle.main.infoDictionary ?? [:]
        let device = UIDevice.current
        configuration.httpAdditionalHeaders = [
            "User-Agent":
                "\(info["CFBundleName"] ?? "HockeyPlayoffs")/\(info["CFBundleShortVersionString"] ?? "") (\(info["CFBundleVersion"] ?? "")) (\(device.model); \(device.systemName) \(device.systemVersion); Scale/\(UIScreen.main.scale))"
        ]
        session = URLSession(configuration: configuration)
    }
    @discardableResult
    func refresh() async -> Bool {
        if let refreshTask { return await refreshTask.value }
        let task = Task { () -> Bool in
            do {
                var components = URLComponents(
                    url: baseURL.appendingPathComponent("Hockey/Playoffs"), resolvingAgainstBaseURL: true)!
                components.queryItems = [URLQueryItem(name: "include_inactive", value: "false")]
                let (data, response) = try await session.data(from: components.url!)
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw URLError(.badServerResponse)
                }
                try Task.checkCancellation()
                try await Task.detached(priority: .utility) {
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        throw URLError(.cannotParseResponse)
                    }
                    try DatabaseHandler.shared.updatePlayoffData(json)
                }.value
                NotificationCenter.default.post(name: .playoffsUpdated, object: nil)
                return true
            } catch {
                if !(error is CancellationError) && (error as? URLError)?.code != .cancelled {
                    ToastHandler.showError(error)
                }
                return false
            }
        }
        refreshTask = task
        let result = await task.value
        refreshTask = nil
        return result
    }
    func cancelRefresh() { refreshTask?.cancel() }
    func startSyncTimer() {
        stopSyncTimer()
        Task { await refresh() }
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            Task { @MainActor in await APIRequestHandler.shared.refresh() }
        }
    }
    func stopSyncTimer() {
        timer?.invalidate()
        timer = nil
    }
}
