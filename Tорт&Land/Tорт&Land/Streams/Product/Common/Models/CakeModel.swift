//
//  CakeModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//

import Foundation

struct CakeModel: Identifiable, Hashable {
    /// Код торта
    let id: String
    /// Состояние изображения
    var thumbnails: [Thumbnail]
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
    /// Описание товара
    var description: String
    /// Схожие товары
    var similarCakes: [CakeModel]
    /// Продовец
    var seller: UserModel
}
