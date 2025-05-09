//
//  CategoryCardModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//

import Foundation
import NetworkAPI
import Core

struct CategoryCardModel: Identifiable, Hashable {
    var id: String
    var title: String
    var imageState: ImageState
}

// MARK: - CategoryEntity

extension CategoryCardModel {
    init(from model: CategoryEntity) {
        self = CategoryCardModel(
            id: model.id,
            title: model.name,
            imageState: .loading
        )
    }
}
