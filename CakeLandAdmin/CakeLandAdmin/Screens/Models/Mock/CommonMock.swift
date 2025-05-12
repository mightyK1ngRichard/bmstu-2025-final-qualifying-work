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
    static var orderMock = OrderModel(
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
}
#endif
