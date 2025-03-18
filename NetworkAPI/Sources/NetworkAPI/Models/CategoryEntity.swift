//
//  CategoryEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 17.03.2025.
//

import Foundation

/// Информация о категории
public struct CategoryEntity: Sendable {
    /// ID категории
    public let id: String
    /// Название категории
    public let name: String
    /// URL изображения категории
    public let imageURL: String
}

// MARK: - Category

extension CategoryEntity {
    init(from model: Category) {
        self = CategoryEntity(id: model.id, name: model.name, imageURL: model.imageURL)
    }
}
