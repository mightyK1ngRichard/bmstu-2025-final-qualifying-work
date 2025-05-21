//
//  Fillings.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

struct Filling: Identifiable, Hashable {
    /// ID начинки
    let id: String
    /// Название начинки
    let name: String
    /// Состояние изображения начинки
    var thumbnail: Thumbnail
    /// Состав начинки
    let content: String
    /// Цена за кг
    let kgPrice: Double
    /// Описание начинки
    let description: String
}

// MARK: - FillingEntity

extension Filling {
    init(from model: FillingEntity) {
        self = Filling(
            id: model.id,
            name: model.name,
            thumbnail: .init(id: UUID().uuidString, imageState: .loading, url: model.imageURL),
            content: model.content,
            kgPrice: model.kgPrice,
            description: model.description
        )
    }
}
