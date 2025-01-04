//
//  CommonMockData.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG
import Foundation

enum CommonMockData {
    static func generateMockCakeModel(id: Int, withDiscount: Bool = true) -> CakeModel {
        CakeModel(
            id: String(id),
            thumbnails: [
                Thumbnail(imageState: .fetched(.uiImage(.cake1))),
                Thumbnail(imageState: .fetched(.uiImage(.cake2))),
                Thumbnail(imageState: .fetched(.uiImage(.cake3))),
            ].shuffled(),
            cakeName: "Моковый торт #\(id)",
            price: 19.99,
            discountedPrice: withDiscount ? 15.99 : nil,
            isSelected: Bool.random(),
            description: Constants.longDescription,
            establishmentDate: Date().description,
            similarCakes: [],
            comments: (1...10).map {
                CommentInfo(
                    id: String($0),
                    author: generateMockUserModel(id: $0, name: "Комментатор #\($0)"),
                    date: "June 5, 2025",
                    description: Constants.longComment,
                    countFillStars: (1...5).randomElement() ?? 1
                )
            },
            seller: generateMockUserModel(id: id, name: "Продавец #\(id)")
        )
    }
    static func generateMockUserModel(id: Int, name: String? = nil) -> UserModel {
        UserModel(
            id: String(id),
            name: name ?? "Имя пользователя #\(id)",
            mail: "email_\(id)@gmail.com",
            avatarImage: .fetched(.uiImage(.king)),
            headerImage: .fetched(.uiImage(.headerKing)),
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
