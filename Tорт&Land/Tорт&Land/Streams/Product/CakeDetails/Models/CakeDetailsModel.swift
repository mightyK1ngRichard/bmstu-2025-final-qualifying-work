//
//  CakeDetailsModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

enum CakeDetailsModel {}

extension CakeDetailsModel {

    struct CakeModel: Identifiable {
        /// Код торта
        let id: String
        /// Картинки торта
        var images: [ImageState]
        /// Флаг если товар нравится
        var isFavorite: Bool
        /// Название торта
        let cakeName: String
        /// Цена торта без скидки
        let price: Double
        /// Цена со скидкой
        let discountedPrice: Double?
        /// Описание товара
        let description: String
        /// Количество звёзд торта
        let fillStarsCount: Int
        /// Количество оценок
        let numberRatings: Int
        /// Схожие товары
        var similarCakes: [CakeModel]
        /// Продовец
        var seller: UserModel
    }

    struct UserModel: Identifiable {
        /// Код пользователя
        let id: String
        /// Имя пользователя
        let name: String
    }
}
