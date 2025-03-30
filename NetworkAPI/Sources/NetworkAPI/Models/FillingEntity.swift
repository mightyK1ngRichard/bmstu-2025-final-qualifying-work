//
//  FillingEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 17.03.2025.
//

import Foundation

public struct FillingEntity: Sendable, Hashable {
    /// ID начинки
    public let id: String
    /// Название начинки
    public let name: String
    /// URL изображения начинки
    public let imageURL: String
    /// Состав начинки
    public let content: String
    /// Цена за кг
    public let kgPrice: Double
    /// Описание начинки
    public let description: String
}

// MARK: - Filling

extension FillingEntity {
    init(from model: Filling) {
        self = FillingEntity(
            id: model.id,
            name: model.name,
            imageURL: model.imageURL,
            content: model.content,
            kgPrice: model.kgPrice,
            description: model.description_p
        )
    }
}
