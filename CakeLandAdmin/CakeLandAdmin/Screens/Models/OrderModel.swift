//
//  OrderModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import Foundation
import NetworkAPI

struct OrderModel: Identifiable, Hashable {
    var id: String
    var totalPrice: Double
    var deliveryAddress: AddressEntity
    var mass: Double
    var filling: FillingEntity
    var deliveryDate: Date
    var sellerID: String
    var paymentMethod: PaymentMethodEntity
    var status: OrderStatusEntity
    var cakeID: String
    var createdAt: String
}

// MARK: - OrderEntity

extension OrderModel {
    init(from model: OrderEntity) {
        self = OrderModel(
            id: model.id,
            totalPrice: model.totalPrice,
            deliveryAddress: model.deliveryAddress,
            mass: model.mass,
            filling: model.filling,
            deliveryDate: model.deliveryDate,
            sellerID: model.sellerID,
            paymentMethod: model.paymentMethod,
            status: model.status,
            cakeID: model.cakeID,
            createdAt: model.createdAt.formattedDDMMYYYYHHmm
        )
    }
}
