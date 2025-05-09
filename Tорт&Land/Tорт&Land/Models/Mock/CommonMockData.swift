//
//  CommonMockData.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG
import Foundation
import NetworkAPI
import UIKit
import Core

enum CommonMockData {
    static func generateMockCakeModel(id: Int, withDiscount: Bool = true) -> CakeModel {
        CakeModel(
            id: String(id),
            previewImageState: .fetched(.uiImage(TLPreviewAssets.cake1)),
            thumbnails: [
                Thumbnail(id: "1", imageState: .fetched(.uiImage(TLPreviewAssets.cake1)), url: ""),
                Thumbnail(id: "2", imageState: .fetched(.uiImage(TLPreviewAssets.cake2)), url: ""),
                Thumbnail(id: "3", imageState: .fetched(.uiImage(TLPreviewAssets.cake3)), url: ""),
            ].shuffled(),
            cakeName: "Моковый торт #\(id)",
            price: 19.99 * Double(id),
            mass: 400,
            discountedPrice: withDiscount ? 15.99 * Double(id) : nil,
            rating: 5,
            reviewsCount: 10,
            isSelected: Bool.random(),
            description: Constants.longDescription,
            establishmentDate: Date().description,
            similarCakes: [
            ],
            comments: (1...10).map {
                CommentInfo(
                    id: String($0),
                    author: generateMockAuthor(id: $0, name: "Комментатор #\($0)"),
                    date: "June 5, 2025",
                    description: Constants.longComment,
                    countFillStars: (1...5).randomElement() ?? 1
                )
            },
            categories: [
                .init(id: "1", name: "Свадебный торт", imageState: .fetched(.uiImage(TLPreviewAssets.categ1))),
                .init(id: "2", name: "Шоколадный торт", imageState: .fetched(.uiImage(TLPreviewAssets.categ5))),
            ],
            fillings: [
                .init(
                    id: "1",
                    name: "Шоколадная начинка",
                    imageState: .fetched(.uiImage(TLPreviewAssets.filling2)),
                    content: "Шоколад, сливки, витамин G",
                    kgPrice: 200,
                    description: "Это очень вкусный коржик"
                ),
                .init(
                    id: "2",
                    name: "Клубничная начинка начинка начинка",
                    imageState: .fetched(.uiImage(TLPreviewAssets.filling1)),
                    content: "Клабника, сливки, витамин L",
                    kgPrice: 200,
                    description: "Это очень вкусный коржик"
                )
            ],
            seller: generateMockUserModel(id: id, name: "Продавец #\(id)"),
            colorsHex: [],
            isOpenForSale: true
        )
    }
    static func generateMockUserModel(
        id: Int,
        name: String? = nil,
        avatar: ImageState? = nil,
        header: ImageState? = nil
    ) -> UserModel {
        UserModel(
            id: String(id),
            fio: name ?? "Имя пользователя #\(id)",
            nickname: "nickname_\(id)",
            avatarImage: avatar ?? .fetched(
                .uiImage(TLPreviewAssets.user1)
            ),
            headerImage: header ?? .fetched(
                .uiImage(TLPreviewAssets.header1)
            ),
            mail: "email_\(id)@gmail.com",
            cakes: []
        )
    }

    static func generateMockAuthor(
        id: Int,
        name: String? = nil,
        avatar: ImageState? = nil
    ) -> CommentInfo.Author {
        .init(
            id: String(id),
            name: name ?? "Имя пользователя #\(id)",
            imageState: avatar ?? .fetched(.uiImage(TLPreviewAssets.king))
        )
    }

    static var refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDczNTUxMjYsInVzZXJJRCI6IjIyODIyNzNmLTk4NmYtNDc0MS04OTM2LWRmMzEyNDhlMzljYiJ9.rR6oDNh-QUWiyvDmPAgFCRrTZqeD8-4y5s6PMTjtHoI"
}

// MARK: - Constants

private extension CommonMockData {
    enum Constants {
        static let longDescription = """
        Состав:
        Бисквит (мука, яйцо, сахар)  Крем (творожный сыр, сливки 33%, сахарная пудра)  Мусс (творожный сыр, сливки 33%, сахар, печенье Орео, загуститель)  Белый шоколад, пищевой краситель
        Размер:
        Ширина - 12 см
        Высота - 8 см
        
        Вес товара:
        700 гр.
        Изготовитель:
        Ms cake
        """
        static let longComment = """
        The dress is great! Very classy and comfortable. It fit perfectly! I'm 5'7" and 130 pounds. I am a 34B chest. This dress would be too long for those who are shorter but could be hemmed. I wouldn't recommend it for those big chested as I am smaller chested and it fit me perfectly. The underarms were not too wide and the dress was made well.
        """
    }
}

#endif
