//
//  AlertModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

struct AlertModel: Hashable {
    var content: AlertContent = .init(title: "", message: "")
    var isShown = false

    var isEmpty: Bool {
        content.isEmpty && !isShown
    }
}
