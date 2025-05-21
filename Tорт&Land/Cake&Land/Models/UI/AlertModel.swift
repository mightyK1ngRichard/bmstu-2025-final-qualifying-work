//
//  AlertModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import DesignSystem

struct AlertModel: Hashable {
    var content = AlertContent(title: "", message: "")
    var isShown = false
}

// MARK: - AlertContent

struct AlertContent: Hashable {
    var title: String = String(localized: "Network error")
    var message: String
}

extension TLErrorView.Configuration {
    init(from content: AlertContent, buttonTitle: String? = nil) {
        self = .init(
            kind: .customError(content.title, content.message),
            buttonTitle: buttonTitle ?? StringConstants.tryAgain
        )
    }
}
