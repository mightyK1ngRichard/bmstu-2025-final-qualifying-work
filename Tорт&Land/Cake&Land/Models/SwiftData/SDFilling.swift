//
//  SDFilling.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 19.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftData
import NetworkAPI

@Model
final class SDFilling: Networkable {
    /// ID начинки
    @Attribute(.unique)
    var fillingID: String
    /// Название начинки
    var name: String
    /// URL изображения начинки
    var imageURL: String
    /// Состав начинки
    var content: String
    /// Цена за кг
    var kgPrice: Double
    /// Описание начинки
    var fillDescription: String

    // :M-M:
    var cakes: [SDCake]?

    init(
        fillingID: String,
        name: String,
        imageURL: String,
        content: String,
        kgPrice: Double,
        fillDescription: String
    ) {
        self.fillingID = fillingID
        self.name = name
        self.imageURL = imageURL
        self.content = content
        self.kgPrice = kgPrice
        self.fillDescription = fillDescription
    }
}

// MARK: - FillingEntity

extension SDFilling {
    convenience init(from model: FillingEntity) {
        self.init(
            fillingID: model.id,
            name: model.name,
            imageURL: model.imageURL,
            content: model.content,
            kgPrice: model.kgPrice,
            fillDescription: model.description
        )
    }

    var asEntity: FillingEntity {
        FillingEntity(
            id: fillingID,
            name: name,
            imageURL: imageURL,
            content: content,
            kgPrice: kgPrice,
            description: fillDescription
        )
    }

    func update(with newEntity: FillingEntity) {
        guard newEntity.id == fillingID else {
            return
        }

        name = newEntity.name
        imageURL = newEntity.imageURL
        content = newEntity.content
        kgPrice = newEntity.kgPrice
        fillDescription = newEntity.description
    }
}
