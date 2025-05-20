//
//  SDCategory.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 19.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import SwiftData

@Model
final class SDCategory: Networkable {
    /// Код категории
    @Attribute(.unique)
    var categoryID: String
    /// Название категории
    var name: String
    /// URL изображения категории
    var imageURL: String
    /// Теги категории (по полу).
    /// - Example: женское, мужское, детское <-> ["женское", "мужское", "детское"]
    var genderTagsJoinedString: String

    // :M-M:
    var cakes: [SDCake]?

    init(
        categoryID: String,
        name: String,
        imageURL: String,
        genderTagsRaws: [String]
    ) {
        self.categoryID = categoryID
        self.name = name
        self.imageURL = imageURL
        self.genderTagsJoinedString = genderTagsRaws.joined(separator: ",")
    }
}

// MARK: - CategoryEntity

extension SDCategory {
    convenience init(from model: CategoryEntity) {
        self.init(
            categoryID: model.id,
            name: model.name,
            imageURL: model.imageURL,
            genderTagsRaws: model.genderTags.map(\.rawValue)
        )
    }

    var asEntity: CategoryEntity {
        let genderArray = genderTagsJoinedString.components(separatedBy: ",")

        return CategoryEntity(
            id: categoryID,
            name: name,
            imageURL: imageURL,
            genderTags: genderArray.compactMap(CategoryGender.init(from:))
        )
    }

    func update(with newEntity: CategoryEntity) {
        guard newEntity.id == categoryID else {
            return
        }

        name = newEntity.name
        imageURL = newEntity.imageURL
    }
}

private extension CategoryGender {
    init?(from rawValue: String) {
        switch rawValue {
        case "male":
            self = .male
        case "female":
            self = .female
        case "child":
            self = .child
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        case .child:
            return "child"
        }
    }
}
