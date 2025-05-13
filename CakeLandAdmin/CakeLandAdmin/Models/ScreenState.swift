//
//  ScreenState.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum ScreenState: Hashable {
    case initial
    case loading
    case finished
    case error(content: ErrorContent)
}

// MARK: - ErrorContent

struct ErrorContent: Hashable {
    var title: String = String(localized: "Network error")
    var message: String

    var isEmpty: Bool {
        message.isEmpty && title.isEmpty
    }
}
