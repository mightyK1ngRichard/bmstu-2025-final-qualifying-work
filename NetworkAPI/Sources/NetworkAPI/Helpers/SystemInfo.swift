//
//  SystemInfo.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import UIKit

@MainActor
struct SystemInfo {
    public static let modelName = UIDevice.current.modelName
    public static let systemVersion = UIDevice.current.systemVersion
}
