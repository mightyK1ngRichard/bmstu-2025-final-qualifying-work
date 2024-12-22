//
//  CakeListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation

enum CakesListModel {}

extension CakesListModel {

    enum Section: Identifiable {
        case all([CakeModel])
        case sale([CakeModel])
        case new([CakeModel])
    }

    struct CakeModel: Identifiable {
        /// Код торта
        let id: String
        /// Состояние изображения
        var imageState: ImageState
        /// Название продавца
        let sellerName: String
        /// Название торта
        let cakeName: String
        /// Цена торта (без скидки)
        let price: Double
        /// Цена со скидкой (если есть)
        let discountedPrice: Double?
        /// Количество заполненных звёзд
        let fillStarsCount: Int
        /// Количество оценок
        let numberRatings: Int
        /// Флаг любимого товара
        var isSelected: Bool
    }
}

// MARK: - Section

extension CakesListModel.Section {

    var id: String {
        switch self {
        case .all:
            return "all"
        case .sale:
            return "sale"
        case .new:
            return "new"
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .new:
            return "New"
        case .sale:
            return "Sale"
        case .all:
            return "All"
        }
    }

    var subtitle: LocalizedStringResource {
        switch self {
        case .new:
            return "You’ve never seen it before!"
        case .sale:
            return "Super summer sale"
        case .all:
            return "You can buy it right now!"
        }
    }
}
