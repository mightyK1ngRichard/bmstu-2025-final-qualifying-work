//
//  AlertManager.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 16.05.2025.
//

import Foundation
import AppKit

final class AlertManager {
    static let shared = AlertManager()
    private init() {}

    func showAlert(title: String, message: String, systemImage: String = "checkmark.circle.fill") {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational

        if let image = NSImage(systemSymbolName: systemImage, accessibilityDescription: nil) {
            alert.icon = image
        }

        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
