//
//  OrderListViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import DesignSystem

@Observable
final class OrderListViewModel {
    var uiProperties = OrderListModel.UIProperties()
    private(set) var orders: [OrderEntity] = []

    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private let orderService: OrderService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService
    @ObservationIgnored
    private var coordinator: Coordinator!

    init(
        cakeService: CakeService,
        orderService: OrderService,
        imageProvider: ImageLoaderProvider,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.cakeService = cakeService
        self.orderService = orderService
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter
    }
}

extension OrderListViewModel {

    func fetchData() {
        uiProperties.state = .loading
        Task { @MainActor in
            do {
                orders = try await orderService.fetchOrders()
                uiProperties.state = .finished
            } catch {
                uiProperties.state = .error(content: error.readableGRPCContent)
            }
        }
    }

    func configureOrderCell(order: OrderEntity) -> OrderCell.Configuration {
        let uuidStr = order.id
        let shortID = uuidStr.prefix(6) + "…" + uuidStr.suffix(4)

        return .init(
            title: "#\(shortID)",
            date: order.deliveryDate.formattedDDMMYYYY,
            addressTitle: order.deliveryAddress.formattedAddress,
            mass: "\(Int(order.mass)) гр",
            totalAmount: priceFormatter.formatPrice(order.totalPrice),
            status: {
                switch order.status {
                case .pending:
                    return .pending
                case .shipped:
                    return .shipped
                case .delivered:
                    return .delivered
                case .cancelled:
                    return .cancelled
                }
            }()
        )
    }

    func didTapOrderCell(order: OrderEntity) {
        coordinator.addScreen(OrderListModel.Screens.orderDetails(order: order))
    }

    func setCoordinators(_ coord: Coordinator) {
        coordinator = coord
    }

    func assemblyOrderDetails(orderEntity: OrderEntity) -> OrderDetailsView {
        OrderDetailsAssemler.assemble(
            orderEntity: orderEntity,
            cakeService: cakeService,
            imageProvider: imageProvider
        )
    }

}
