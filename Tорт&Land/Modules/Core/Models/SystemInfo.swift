//
//  SystemInfo.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import UIKit

public struct SystemInfo {
    private static let device = UIDevice.current
    private static let screen = UIScreen.main
    private static let bundle = Bundle.main
    public static let systemVersion = device.systemVersion
    public static let modelName = device.modelName
    public static let width = screen.bounds.width
    public static let height = screen.bounds.height
    public static let bounds = screen.bounds
    public static let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}
