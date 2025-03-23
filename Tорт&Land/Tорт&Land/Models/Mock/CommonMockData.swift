//
//  CommonMockData.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG
import Foundation
import UIKit

enum CommonMockData {
    static func generateMockCakeModel(id: Int, withDiscount: Bool = true) -> CakeModel {
        CakeModel(
            id: String(id),
            previewImageState: .fetched(.uiImage(.cake1)),
            thumbnails: [
                Thumbnail(id: "1", imageState: .fetched(.uiImage(.cake1)), url: ""),
                Thumbnail(id: "2", imageState: .fetched(.uiImage(.cake2)), url: ""),
                Thumbnail(id: "3", imageState: .fetched(.uiImage(.cake3)), url: ""),
            ].shuffled(),
            cakeName: "Моковый торт #\(id)",
            price: 19.99,
            discountedPrice: withDiscount ? 15.99 : nil,
            rating: 5,
            isSelected: Bool.random(),
            description: Constants.longDescription,
            establishmentDate: Date().description,
            similarCakes: [
            ],
            comments: (1...10).map {
                CommentInfo(
                    id: String($0),
                    author: generateMockUserModel(id: $0, name: "Комментатор #\($0)"),
                    date: "June 5, 2025",
                    description: Constants.longComment,
                    countFillStars: (1...5).randomElement() ?? 1
                )
            },
            categories: [
                .init(id: "1", name: "Свадебный торт", imageState: .fetched(.uiImage(.categ1))),
                .init(id: "2", name: "Шоколадный торт", imageState: .fetched(.uiImage(.categ5))),
            ],
            fillings: [
                .init(
                    id: "1",
                    name: "Шоколадная начинка",
                    imageState: .fetched(.uiImage(.filling2)),
                    content: "Шоколад, сливки, витамин G",
                    kgPrice: 200,
                    description: "Это очень вкусный коржик"
                ),
                .init(
                    id: "2",
                    name: "Клубничная начинка начинка начинка",
                    imageState: .fetched(.uiImage(.filling1)),
                    content: "Клабника, сливки, витамин L",
                    kgPrice: 200,
                    description: "Это очень вкусный коржик"
                )
            ],
            seller: generateMockUserModel(id: id, name: "Продавец #\(id)")
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
            name: name ?? "Имя пользователя #\(id)",
            mail: "email_\(id)@gmail.com",
            avatarImage: avatar ?? .fetched(
                .uiImage(UIImage(named: "user\(Int.random(in: 1...7))") ?? .user1)
            ),
            headerImage: header ?? .fetched(
                .uiImage(UIImage(named: "header\(Int.random(in: 1...6))") ?? .header1)
            ),
            cakes: []
        )
    }
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
