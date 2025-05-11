//
//  OrderServiceModel.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

public enum OrderServiceModel {
    public enum MakeOrder {}
}

// MARK: - MakeOrder

public extension OrderServiceModel.MakeOrder {
    struct Request: Sendable {
        let totalPrice: Double
        let deliveryAddressID: String
        let mass: Double
        let paymentMethod: PaymentMethodEntity
        let deliveryDate: Date
        let fillingID: String
        let sellerID: String
        let cakeID: String

        public init(
            totalPrice: Double,
            deliveryAddressID: String,
            mass: Double,
            paymentMethod: PaymentMethodEntity,
            deliveryDate: Date,
            fillingID: String,
            sellerID: String,
            cakeID: String
        ) {
            self.totalPrice = totalPrice
            self.deliveryAddressID = deliveryAddressID
            self.mass = mass
            self.paymentMethod = paymentMethod
            self.deliveryDate = deliveryDate
            self.fillingID = fillingID
            self.sellerID = sellerID
            self.cakeID = cakeID
        }
    }
}
