//
//  SDCakeImage.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 20.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import NetworkAPI
import SwiftData

@Model
final class SDCakeImage: Networkable {
    @Attribute(.unique)
    var imageID: String
    var imageURL: String
    // :1-M:
    var cake: SDCake?

    init(from model: CakeEntity.CakeImageEntity) {
        imageID = model.id
        imageURL = model.imageURL
    }

    var asEntity: CakeEntity.CakeImageEntity {
        .init(id: imageID, imageURL: imageURL)
    }

    func updated(with newEntity: CakeEntity.CakeImageEntity) {
        guard newEntity.id == imageID else {
            return
        }

        imageID = newEntity.id
        imageURL = newEntity.imageURL
    }
}
