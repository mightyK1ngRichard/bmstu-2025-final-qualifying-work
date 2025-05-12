//
//  Category.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

/// Информация о категории
struct Category: Identifiable, Hashable {
    /// ID категории
    let id: String
    /// Название категории
    let name: String
    /// Состояние изображения категории
    var thumbnail: Thumbnail
}

// MARK: - CategoryEntity

extension Category {
    init(from model: CategoryEntity) {
        self = Category(
            id: model.id,
            name: model.name,
            thumbnail: .init(
                id: UUID().uuidString,
                imageState: .loading,
                url: model.imageURL
            )
        )
    }
}
