//
//  CakeModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
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
    /// Флаг любимого товара
    var isSelected: Bool
    /// Описание товара
    var description: String
    /// Схожие товары
    var similarCakes: [CakeModel]
    /// Комментарии
    var comments: [CommentInfo] = []
    /// Продовец
    var seller: UserModel
}
