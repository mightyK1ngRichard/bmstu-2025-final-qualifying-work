//
//  CakeEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 23.03.2025.
//

import Foundation

/// Подробная информация о торте
public struct CakeEntity: Sendable, Hashable {
    /// Код торта
    public let id: String
    /// Название
    public let name: String
    /// Картинка
    public let imageURL: String
    /// Цена за кг
    public let kgPrice: Double
    /// Рейтинг (от 0 до 5)
    public let rating: Int
    /// Число отзывов
    public let reviewsCount: Int
    /// Описание
    public let description: String
    /// Масса торта
    public let mass: Double
    /// Флаг возможности продажи торта
    public let isOpenForSale: Bool
    /// Дата создания торта
    public let dateCreation: Date
    /// Скидочная цена за кг
    public let discountKgPrice: Double?
    /// Дата окончания скидки
    public let discountEndTime: Date?
    /// Владелец
    public let owner: UserEntity
    /// Начинки торта
    public let fillings: [FillingEntity]
    /// Категории торта
    public let categories: [CategoryEntity]
    /// Фотографии торта
    public let images: [CakeImageEntity]
    /// Hex цвета торта
    public var colorsHex: [String]
}

public extension CakeEntity {
    /// Изображения торта
    struct CakeImageEntity: Sendable, Hashable {
        /// Код изображения
        public let id: String
        /// Ссылка на изображение
        public let imageURL: String
    }
}

// MARK: - Cake

extension CakeEntity {
    init(from model: Cake_Cake) {
        self = CakeEntity(
            id: model.id,
            name: model.name,
            imageURL: model.imageURL,
            kgPrice: model.kgPrice,
            rating: Int(model.rating),
            reviewsCount: Int(model.reviewsCount),
            description: model.description_p,
            mass: model.mass,
            isOpenForSale: model.isOpenForSale,
            dateCreation: model.dateCreation.date,
            discountKgPrice: model.hasDiscountKgPrice ? model.discountKgPrice : nil,
            discountEndTime: model.hasDiscountEndTime ? model.discountEndTime.date : nil,
            owner: UserEntity(from: model.owner),
            fillings:  model.fillings.map(FillingEntity.init(from:)),
            categories: model.categories.map(CategoryEntity.init(from:)),
            images: model.images.map(CakeImageEntity.init(from:)),
            colorsHex: []
        )
    }
}

extension CakeEntity.CakeImageEntity {
    init(from model: Cake_Cake.CakeImage) {
        self = .init(id: model.id, imageURL: model.imageURL)
    }
}

// MARK: - CakeEntity

public extension CakeEntity {
    init(from model: PreviewCakeEntity) {
        self = CakeEntity(
            id: model.id,
            name: model.name,
            imageURL: model.imageURL,
            kgPrice: model.kgPrice,
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            description: model.description,
            mass: model.mass,
            isOpenForSale: model.isOpenForSale,
            dateCreation: model.dateCreation,
            discountKgPrice: model.discountKgPrice,
            discountEndTime: model.discountEndTime,
            owner: model.owner,
            fillings: model.fillings,
            categories: model.categories,
            images: [],
            colorsHex: model.colorsHex
        )
    }
}
