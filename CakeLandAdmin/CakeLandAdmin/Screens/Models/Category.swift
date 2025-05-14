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
    /// Теги категории (по полу)
    let genderTags: [Gender]
}

// MARK: - Gender

extension Category {
    enum Gender: String, Hashable, CaseIterable {
        case male
        case female
        case child
    }
}

extension Category.Gender {
    init(from model: CategoryGender) {
        switch model {
        case .child:
            self = .child
        case .female:
            self = .female
        case .male:
            self = .male
        }
    }

    var toProto: CategoryGender {
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
            ),
            genderTags: model.genderTags.map(Category.Gender.init(from:))
        )
    }
}
