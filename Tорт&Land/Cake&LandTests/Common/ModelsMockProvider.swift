//
//  ModelsMockProvider.swift
//  Tорт&LandTests
//
//  Created by Dmitriy Permyakov on 28.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
@testable import NetworkAPI

final class ModelsMockProvider {

    static let cakeEntity = generateCakeEntity(id: 1)

    static let userEntity = UserEntity(
        id: "1",
        fio: "King Richard",
        nickname: "mightyK1ngRichard",
        mail: "dimapermyakov@gmail.com",
        imageURL: nil,
        headerImageURL: nil
    )

    static func generateCakeEntity(id: Int) -> CakeEntity {
        CakeEntity(
            id: String(id),
            name: "Mock test cake name #\(id)",
            imageURL: "image/url",
            kgPrice: 1000,
            rating: 5,
            description: "Mock test cake description: #\(id)",
            mass: 2,
            isOpenForSale: true,
            dateCreation: Date(timeIntervalSince1970: 1672531199),
            discountKgPrice: nil,
            discountEndTime: nil,
            owner: userEntity,
            fillings: [],
            categories: [],
            images: []
        )
    }

}
