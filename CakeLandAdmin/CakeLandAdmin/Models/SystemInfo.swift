//
//  SystemInfo.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import Foundation
import AppKit

public struct SystemInfo {
    private static let processInfo = ProcessInfo.processInfo
    private static let bundle = Bundle.main
    private static let screen = NSScreen.main

    public static let systemVersion = processInfo.operatingSystemVersionString
    public static let modelIdentifier = getModelIdentifier()
    public static let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    public static let screenSize: CGSize = screen?.frame.size ?? .zero

    private static func getModelIdentifier() -> String {
        var size: Int = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &machine, &size, nil, 0)
        return String(cString: machine)
    }
}
