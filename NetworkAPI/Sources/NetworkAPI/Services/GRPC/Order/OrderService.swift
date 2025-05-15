//
//  OrderService.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import GRPC
import NIO
import SwiftProtobuf

// MARK: - OrderService

public protocol OrderService: Sendable {
    func makeOrder(req: OrderServiceModel.MakeOrder.Request) async throws -> String
    func fetchOrders() async throws -> [OrderEntity]
    func fetchOrderByID(orderID: String) async throws -> OrderEntity
    func fetchAllOrders() async throws -> [OrderEntity]
    func updateOrderStatus(orderID: String, newStatus: OrderStatusEntity) async throws
    func closeConnection()
}

// MARK: - OrderGrpcServiceImpl

public final class OrderGrpcServiceImpl: OrderService {
    private let client: Order_OrderServiceAsyncClient
    private let channel: GRPCChannel
    private let authService: AuthService
    private let networkService: NetworkService

    public init(
        configuration: GRPCHostPortConfiguration,
        authService: AuthService,
        networkService: NetworkService
    ) {
        do {
            let channel = try ConfigProvider.makeConection(
                host: configuration.hostName,
                port: configuration.port,
                numberOfThreads: 1
            )
            self.client = Order_OrderServiceAsyncClient(channel: channel, interceptors: nil)
            self.channel = channel
            self.authService = authService
            self.networkService = networkService
        } catch {
            #if DEBUG
            fatalError("Ошибка подключения к grpc серверу заказа: \(error)")
            #else
            Logger.log(kind: .error, "Ошибка подключения к grpc серверу заказа: \(error)")
            assertionFailure("Ошибка подключения к grpc серверу: \(error)")
            fatalError("Ошибка подключения к grpc серверу профиля: \(error)")
            #endif
        }
    }
}

public extension OrderGrpcServiceImpl {

    func updateOrderStatus(orderID: String, newStatus: OrderStatusEntity) async throws {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Order_UpdateOrderStateReq.with {
            $0.orderID = orderID
            $0.updatedStatus = newStatus.toProto
        }

        return try await networkService.performAndLog(
            call: client.updateOrderStatus,
            with: request,
            mapping: { _ in }
        )
    }

    /// Получение всех заказов.
    /// - Important: Этот метод предназначен **только для администратора**.
    /// Не используйте его на клиентской стороне без соответствующих проверок доступа.
    func fetchAllOrders() async throws -> [OrderEntity] {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.getAllOrders,
            with: request,
            mapping: { $0.orders.map(OrderEntity.init(from:)) }
        )
    }

    func fetchOrderByID(orderID: String) async throws -> OrderEntity {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Order_OrderByIDReq.with {
            $0.orderID = orderID
        }

        return try await networkService.performAndLog(
            call: client.orderByID,
            with: request,
            mapping: { OrderEntity(from: $0.order) }
        )
    }

    func fetchOrders() async throws -> [OrderEntity] {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Google_Protobuf_Empty()
        return try await networkService.performAndLog(
            call: client.orders,
            with: request,
            mapping: { $0.orders.map(OrderEntity.init(from:)) }
        )
    }

    func makeOrder(req: OrderServiceModel.MakeOrder.Request) async throws -> String {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Order_MakeOrderReq.with {
            $0.totalPrice = req.totalPrice
            $0.deliveryAddressID = req.deliveryAddressID
            $0.mass = req.mass
            $0.paymentMethod = .init(rawValue: req.paymentMethod.rawValue) ?? .cash
            $0.deliveryDate = .init(date: req.deliveryDate)
            $0.fillingID = req.fillingID
            $0.sellerID = req.sellerID
            $0.cakeID = req.cakeID
        }

        return try await networkService.performAndLog(
            call: client.makeOrder,
            with: request,
            mapping: { $0.orderID }
        )
    }

    func closeConnection() {
        do {
            try channel.close().wait()
        } catch {
            Logger.log(kind: .error, error)
        }
    }

}
