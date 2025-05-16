//
//  OrderEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//

import Foundation

// MARK: - OrderEntity

public struct OrderEntity: Sendable, Hashable {
    public let id: String
    public let totalPrice: Double
    public let deliveryAddress: AddressEntity
    public let mass: Double
    public let filling: FillingEntity
    public let deliveryDate: Date
    public let sellerID: String
    public let paymentMethod: PaymentMethodEntity
    public let status: OrderStatusEntity
    public let cakeID: String
    public let createdAt: Date
    public let updatedAt: Date
}

// MARK: - PaymentMethodEntity

public enum PaymentMethodEntity: Int, Sendable, Hashable {
    case cash = 0
    case ioMoney = 1
}

// MARK: - OrderStatusEntity

public enum OrderStatusEntity: Sendable, Hashable, CaseIterable {
    /// Заказ создан и ожидает обработки.
    case pending
    /// Заказ находится в пути
    case shipped
    /// Заказ был успешно выполнен и доставлен.
    case delivered
    /// Заказ отменён.
    case cancelled
}

// MARK: - Proto

extension OrderEntity {
    init(from model: Order_Order) {
        let method: PaymentMethodEntity = {
            switch model.paymentMethod {
            case .cash:
                return .cash
            case .iomoney:
                return .ioMoney
            case .UNRECOGNIZED:
                return .cash
            }
        }()
        let status: OrderStatusEntity = {
            switch model.status {
            case .pending:
                return .pending
            case .shipped:
                return .shipped
            case .delivered:
                return .delivered
            case .cancelled:
                return .cancelled
            case .UNRECOGNIZED:
                return .pending
            }
        }()

        self = OrderEntity(
            id: model.id,
            totalPrice: model.totalPrice,
            deliveryAddress: AddressEntity(from: model.deliveryAddress),
            mass: model.mass,
            filling: FillingEntity(from: model.filling),
            deliveryDate: model.deliveryDate.date,
            sellerID: model.sellerID,
            paymentMethod: method,
            status: status,
            cakeID: model.cakeID,
            createdAt: model.createdAt.date,
            updatedAt: model.updatedAt.date
        )
    }
}

extension OrderStatusEntity {
    var toProto: Order_OrderStatus {
        switch self {
        case .pending:
            return .pending
        case .shipped:
            return .shipped
        case .delivered:
            return .delivered
        case .cancelled:
            return .cancelled
        }
    }
}
