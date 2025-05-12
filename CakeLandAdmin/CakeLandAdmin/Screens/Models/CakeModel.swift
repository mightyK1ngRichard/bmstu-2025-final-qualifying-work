//
//  CakeModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import Foundation
import NetworkAPI

struct CakeModel: Identifiable, Hashable {
    /// Код торта
    let id: String
    /// Изображение карточки товара
    var previewImage: Thumbnail
    /// Состояние изображений
    var thumbnails: [Thumbnail]
    /// Название торта
    var cakeName: String
    /// Цена торта (без скидки)
    var price: Double
    /// Масса торта (в граммах)
    var mass: Double
    /// Цена со скидкой (если есть)
    var discountedPrice: Double?
    /// Рейтинг торта (от 0 до 5)
    var rating: Int
    /// Число отзывов
    var reviewsCount: Int
    /// Описание товара
    var description: String
    /// Дата создания товара
    var establishmentDate: String
    /// Категории торта
    var categories: [Category]
    /// Начинки торта
    var fillings: [Filling]
    /// Продовец
    var seller: UserModel
    /// Hex цвета торта
    var colorsHex: [String]
    /// Ссылка на 3Д модель
    var model3DURL: String?
    /// Флаг, открыт ли для продажи
    var isOpenForSale: Bool
}

extension CakeModel {
    init(from model: CakeEntity) {
        self = CakeModel(
            id: model.id,
            previewImage: Thumbnail(url: model.imageURL),
            thumbnails: model.images.map {
                Thumbnail(id: $0.id, imageState: .loading, url: $0.imageURL)
            },
            cakeName: model.name,
            price: model.kgPrice,
            mass: model.mass,
            discountedPrice: {
                guard let discountKgPrice = model.discountKgPrice, let discountEndTime = model.discountEndTime else {
                    return nil
                }

                return discountEndTime < Date.now ? nil : discountKgPrice
            }(),
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            description: model.description,
            establishmentDate: model.dateCreation.description,
            categories: model.categories.map(Category.init(from:)),
            fillings: model.fillings.map(Filling.init(from:)),
            seller: UserModel(from: model.owner),
            colorsHex: model.colorsHex,
            model3DURL: model.model3DURL,
            isOpenForSale: model.isOpenForSale
        )
    }
}
