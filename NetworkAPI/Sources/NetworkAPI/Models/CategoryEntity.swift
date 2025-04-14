//
//  CategoryEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 17.03.2025.
//

import Foundation

/// Информация о категории
public struct CategoryEntity: Sendable, Hashable {
    /// ID категории
    public let id: String
    /// Название категории
    public let name: String
    /// URL изображения категории
    public let imageURL: String
    /// Теги категории (по полу)
    public let genderTags: [CategoryGender]
}

/// Пол категории
public enum CategoryGender: Sendable, Hashable {
    case male
    case female
    case child
}

// MARK: - Category

extension CategoryEntity {
    init(from model: Cake_Category) {
        self = CategoryEntity(
            id: model.id,
            name: model.name,
            imageURL: model.imageURL,
            genderTags: model.genderTags.compactMap(CategoryGender.init(from:))
        )
    }
}

extension CategoryGender {
    init?(from model: Cake_CategoryGender) {
        switch model {
        case .unspecified, .UNRECOGNIZED:
            return nil
        case .male:
            self = .male
        case .female:
            self = .female
        case .child:
            self = .child
        }
    }

    func convertToGrpcModel() -> Cake_CategoryGender {
        switch self {
        case .male:
            return .male
        case .female:
            return .female
        case .child:
            return .child
        }
    }
}
