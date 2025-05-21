//
//  SDCake.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 19.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import SwiftData

@Model
final class SDCake {
    /// Код торта
    @Attribute(.unique)
    var cakeID: String
    /// Название
    var name: String
    /// Картинка
    var imageURL: String
    /// Цена за кг
    var kgPrice: Double
    /// Рейтинг (от 0 до 5)
    var rating: Int
    /// Число отзывов
    var reviewsCount: Int
    /// Описание
    var cakeDescription: String
    /// Масса торта
    var mass: Double
    /// Статус торта
    var statusRaw: Int
    /// Дата создания торта
    var dateCreation: Date
    /// Скидочная цена за кг
    var discountKgPrice: Double?
    /// Дата окончания скидки
    var discountEndTime: Date?
    /// Владелец
    var owner: SDUser?
    /// Начинки торта
    @Relationship(inverse: \SDFilling.cakes)
    var fillings: [SDFilling]?
    /// Категории торта
    @Relationship(inverse: \SDCategory.cakes)
    var categories: [SDCategory]?
    /// Фотографии торта
    @Relationship(deleteRule: .cascade)
    var images: [SDCakeImage]?
    /// Hex цвета торта
    var colorsHex: String
    /// Ссылка на 3Д модель
    var model3DURL: String?

    init(
        cakeID: String,
        name: String,
        imageURL: String,
        kgPrice: Double,
        rating: Int,
        reviewsCount: Int,
        cakeDescription: String,
        mass: Double,
        statusRaw: Int,
        dateCreation: Date,
        discountKgPrice: Double?,
        discountEndTime: Date?,
        colorsHex: [String],
        model3DURL: String?
    ) {
        self.cakeID = cakeID
        self.name = name
        self.imageURL = imageURL
        self.kgPrice = kgPrice
        self.rating = rating
        self.reviewsCount = reviewsCount
        self.cakeDescription = cakeDescription
        self.mass = mass
        self.statusRaw = statusRaw
        self.dateCreation = dateCreation
        self.discountKgPrice = discountKgPrice
        self.discountEndTime = discountEndTime
        self.colorsHex = colorsHex.joined(separator: ",")
        self.model3DURL = model3DURL
    }
}

extension SDCake {

    convenience init(from model: CakeEntity) {
        self.init(
            cakeID: model.id,
            name: model.name,
            imageURL: model.imageURL,
            kgPrice: model.kgPrice,
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            cakeDescription: model.description,
            mass: model.mass,
            statusRaw: model.status.rawValue,
            dateCreation: model.dateCreation,
            discountKgPrice: model.discountKgPrice,
            discountEndTime: model.discountEndTime,
            colorsHex: model.colorsHex,
            model3DURL: model.model3DURL
        )
    }

    convenience init(from model: PreviewCakeEntity) {
        self.init(
            cakeID: model.id,
            name: model.name,
            imageURL: model.imageURL,
            kgPrice: model.kgPrice,
            rating: model.rating,
            reviewsCount: model.reviewsCount,
            cakeDescription: model.description,
            mass: model.mass,
            statusRaw: model.status.rawValue,
            dateCreation: model.dateCreation,
            discountKgPrice: model.discountKgPrice,
            discountEndTime: model.discountEndTime,
            colorsHex: model.colorsHex,
            model3DURL: model.model3DURL
        )
    }

    var asCakeEntity: CakeEntity? {
        guard let owner else {
            return nil
        }

        return CakeEntity(
            id: cakeID,
            name: name,
            imageURL: imageURL,
            kgPrice: kgPrice,
            rating: rating,
            reviewsCount: reviewsCount,
            description: cakeDescription,
            mass: mass,
            status: CakeStatusEntity(rawValue: statusRaw) ?? .unspecified,
            dateCreation: dateCreation,
            discountKgPrice: discountKgPrice,
            discountEndTime: discountEndTime,
            owner: owner.asEntity,
            fillings: fillings?.compactMap(\.asEntity) ?? [],
            categories: categories?.compactMap(\.asEntity) ?? [],
            images: images?.compactMap(\.asEntity) ?? [],
            colorsHex: colorsHex.components(separatedBy: ","),
            model3DURL: model3DURL
        )
    }

    var asPreviewEntity: PreviewCakeEntity? {
        guard let owner else {
            return nil
        }

        return PreviewCakeEntity(
            id: cakeID,
            name: name,
            imageURL: imageURL,
            kgPrice: kgPrice,
            rating: rating,
            reviewsCount: reviewsCount,
            description: cakeDescription,
            mass: mass,
            status: CakeStatusEntity(rawValue: statusRaw) ?? .unspecified,
            owner: owner.asEntity,
            fillings: fillings?.map(\.asEntity) ?? [],
            categories: categories?.map(\.asEntity) ?? [],
            colorsHex: colorsHex.components(separatedBy: ","),
            discountKgPrice: discountKgPrice,
            discountEndTime: discountEndTime,
            dateCreation: dateCreation,
            model3DURL: model3DURL
        )
    }

    func update(with newEntity: PreviewCakeEntity) {
        guard cakeID == newEntity.id else {
            return
        }

        name = newEntity.name
        imageURL = newEntity.imageURL
        kgPrice = newEntity.kgPrice
        rating = newEntity.rating
        reviewsCount = newEntity.reviewsCount
        cakeDescription = newEntity.description
        mass = newEntity.mass
        statusRaw = newEntity.status.rawValue
        dateCreation = newEntity.dateCreation
        discountKgPrice = newEntity.discountKgPrice
        discountEndTime = newEntity.discountEndTime
        colorsHex = newEntity.colorsHex.joined(separator: ",")
        model3DURL = newEntity.model3DURL
    }

    func update(with newEntity: CakeEntity) {
        guard cakeID == newEntity.id else {
            return
        }

        name = newEntity.name
        imageURL = newEntity.imageURL
        kgPrice = newEntity.kgPrice
        rating = newEntity.rating
        reviewsCount = newEntity.reviewsCount
        cakeDescription = newEntity.description
        mass = newEntity.mass
        statusRaw = newEntity.status.rawValue
        dateCreation = newEntity.dateCreation
        discountKgPrice = newEntity.discountKgPrice
        discountEndTime = newEntity.discountEndTime
        colorsHex = newEntity.colorsHex.joined(separator: ",")
        model3DURL = newEntity.model3DURL
    }

}
