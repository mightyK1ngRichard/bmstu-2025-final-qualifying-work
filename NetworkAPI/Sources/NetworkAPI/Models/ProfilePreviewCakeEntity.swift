//
//  ProfilePreviewCakeEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 09.04.2025.
//

import Foundation

public struct ProfilePreviewCakeEntity: Sendable, Hashable {
    /// UUID
    public let id: String
    /// Название
    public let name: String
    /// URL изображения
    public let previewImageURL: String
    /// Цена за килограмм
    public let kgPrice: Double
    /// Рейтинг
    public let rating: Int
    /// Число отзывов
    public let reviewsCount: Int
    /// Описание (nullable)
    public let description: String?
    /// Масса
    public let mass: Double
    /// Скидочная цена за кг (nullable)
    public let discountKgPrice: Double?
    /// Время окончания скидки (nullable)
    public let discountEndTime: Date
    /// Время создания
    public let dateCreation: Date
    /// Продается ли
    public let isOpenForSale: Bool
    /// Владелец
    public let owner: UserEntity
    /// Ссылка на 3Д модель
    public let model3DURL: String?
}

// MARK: - Cake_PreviewCake

extension ProfilePreviewCakeEntity {
    init(from model: Cake_PreviewCake) {
        self = ProfilePreviewCakeEntity(
            id: model.id,
            name: model.name,
            previewImageURL: model.previewImageURL,
            kgPrice: model.kgPrice,
            rating: Int(model.rating),
            reviewsCount: Int(model.reviewsCount),
            description: model.hasDescription_p ? model.description_p.value : nil,
            mass: model.mass,
            discountKgPrice: model.hasDiscountKgPrice ? model.discountKgPrice.value : nil,
            discountEndTime: model.discountEndTime.date,
            dateCreation: model.dateCreation.date,
            isOpenForSale: model.isOpenForSale,
            owner: UserEntity(from: model.owner),
            model3DURL: model.model3Durl
        )
    }
}
