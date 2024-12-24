//
//  CommonMockData.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//

#if DEBUG
import Foundation

enum CommonMockData {
    static func generateMockCakeModel(id: Int) -> CakeModel {
        CakeModel(
            id: String(id),
            thumbnails: [
                .init(imageState: .fetched(.uiImage(.cake1))),
                .init(imageState: .fetched(.uiImage(.cake2))),
                .init(imageState: .fetched(.uiImage(.cake3))),
            ].shuffled(),
            cakeName: "Моковый торт #\(id)",
            price: 19.99,
            discountedPrice: 15.99,
            fillStarsCount: id % 5,
            numberRatings: id,
            isSelected: id % 2 == 0,
            description: Constants.longDescription,
            similarCakes: [],
            seller: .init(id: "2", name: "Продавец Николай")
        )
    }
    static func generateMockUserModel(id: Int) -> UserModel {
        UserModel(id: String(id), name: "User name #\(id)")
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
    }
}

#endif
