//
//  ToastHandler.swift
//  HockeyPlayoffs
//
//  Created by Pierre-Marc Airoldi on 2025-03-07.
//  Copyright © 2025 Pierre-Marc Airoldi. All rights reserved.
//

import Foundation
import Toast

@objc public class ToastHandler: NSObject {
    
    @objc public static func show(_ message: String) -> Void {
        DispatchQueue.main.async {
            let toast = Toast.text(message)
            toast.show()
        }
    }

    @objc public static func showError(_ error: Error) -> Void {
        show(error.localizedDescription)
    }
}
