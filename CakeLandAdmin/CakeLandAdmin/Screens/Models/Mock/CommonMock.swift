//
//  CommonMock.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

#if DEBUG
import Foundation
@testable import NetworkAPI

enum CommonMock {
    static let orderMock = OrderModel(
        id: "cf4ed963-f2d9-4c3b-ac99-a935be0a8c1a",
        totalPrice: 3689.99,
        deliveryAddress: AddressEntity(
            id: "05fe6bad-4f82-4b3c-b075-9b7987a3be67",
            latitude: 17.96238,
            longitude: -76.8718527,
            formattedAddress: "Портмор, Ямайка",
            entrance: "9",
            floor: "9",
            apartment: "249",
            comment: nil
        ),
        mass: 2050,
        filling: FillingEntity(
            id: "550e8400-e29b-41d4-a716-446655440046",
            name: "Фисташковая",
            imageURL: "https://i.pinimg.com/originals/6c/e7/92/6ce79265f58d5ee2920ea622a889073d.jpg",
            content: "Фисташки, крем-чиз, сливки",
            kgPrice: 1450,
            description: "Премиальная начинка с насыщенным ореховым вкусом"
        ),
        deliveryDate: Date(timeIntervalSince1970: 1747094400),
        sellerID: "550e8400-e29b-41d4-a716-446655440021",
        paymentMethod: .cash,
        status: .delivered,
        cakeID: "550e8400-e29b-41d4-a716-446655441203",
        createdAt: Date().description
    )
    static let cakeMock = CakeModel(
        id: "57ae877b-64b0-4ac2-8775-d453e5116f9b",
        previewImage: Thumbnail(id: "1", imageState: .nsImage(.defaultHeader), url: "http://localhost:9000/cake-land-server/d20b6cdf-f37f-4f96-96a6-1338057d5429"),
        thumbnails: [],
        cakeName: "Птичье молоко",
        kgPrice: 2300,
        mass: 340,
        discountedKgPrice: 2200,
        discountedEndDate: Date(),
        rating: 0,
        reviewsCount: 0,
        description: "Торт “Птичье молоко” — это легендарный десерт с нежнейшей структурой, сочетающий воздушный суфле-мусс и тонкие слои бисквита.\nЛегкая, почти невесомая текстура тает во рту, оставляя приятное сливочно-ванильное послевкусие.\nТончайший слой шоколадной глазури придаёт торту утончённую сладость и завершённость вкуса.\n“Птичье молоко” идеально подойдёт для торжественного события или уютного чаепития, наполняя момент лёгкостью и нежностью.",
        establishmentDate: Date(),
        categories: [],
        fillings: [],
        seller: UserModel(
            id: "32067e38-0271-4487-b0f7-2c54dacbbf75",
            fio: "Месси",
            nickname: "messi",
            avatarImage: Thumbnail(id: "1", imageState: .nsImage(.profile), url: ""),
            headerImage: Thumbnail(id: "2", imageState: .nsImage(.defaultHeader), url: ""),
            mail: "testuser4@gmail.com"
        ),
        colorsHex: ["#9ca8b7", "#b96d43", "#d16768", "#dcd8c7", "#c6ad7b"],
        status: .approved
    )
}
#endif
