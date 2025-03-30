//
//  PreviewCakeEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 17.03.2025.
//

import Foundation

public struct PreviewCakeEntity: Sendable, Hashable {
    /// ID торта
    public let id: String
    /// Название торта
    public let name: String
    /// URL изображения торта
    public let imageURL: String
    /// Цена за кг
    public let kgPrice: Double
    /// Рейтинг (0-5)
    public let rating: Int
    /// Описание торта
    public let description: String
    /// Масса торта (кг)
    public let mass: Double
    /// Доступен ли для продажи
    public let isOpenForSale: Bool
    /// Информация о владельце
    public let owner: UserEntity
    /// Список начинок
    public let fillings: [FillingEntity]
    /// Список категорий
    public let categories: [CategoryEntity]
    /// Скидка на цену за кг
    public let discountKgPrice: Double?
    /// Дата окончания скидки
    public let discountEndTime: Date?
    /// Дата создания торта
    public let dateCreation: Date
}

// MARK: - Cake

extension PreviewCakeEntity {
    init(from model: Cake) {
        self = PreviewCakeEntity(
            id: model.id,
            name: model.name,
            imageURL: model.imageURL,
            kgPrice: model.kgPrice,
            rating: Int(model.rating),
            description: model.description_p,
            mass: model.mass,
            isOpenForSale: model.isOpenForSale,
            owner: UserEntity(from: model.owner),
            fillings: model.fillings.map { FillingEntity(from: $0) },
            categories: model.categories.map { CategoryEntity(from: $0) },
            discountKgPrice: model.hasDiscountKgPrice ? model.discountKgPrice : nil,
            discountEndTime: model.hasDiscountEndTime ? model.discountEndTime.date : nil,
            dateCreation: model.dateCreation.date
        )
    }
}

public extension PreviewCakeEntity {
    /// Флаг, новый ли торт. Торт считается новым, если разница меньше 8 дн
    var isNew: Bool {
        let componentsDif = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: dateCreation,
            to: Date.now
        )
        guard componentsDif.month == 0 && componentsDif.year == 0 else {
            return false
        }

        // Получаем разницу нынешней даты и даты создания объявления
        guard let difDay = componentsDif.day else {
            return false
        }

        // Если разница меньше 8, объявление считается новым
        return difDay < 8
    }
}
