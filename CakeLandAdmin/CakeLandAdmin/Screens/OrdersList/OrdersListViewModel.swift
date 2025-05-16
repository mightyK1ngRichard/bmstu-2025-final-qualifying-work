//
//  OrdersListViewModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import Foundation
import NetworkAPI
import Observation
import SwiftUI
import MacDS

extension OrdersListViewModel {
    var sortedOrders: [OrderModel] {
        switch bindingData.sortDirection {
        case .ascending:
            return orders.sorted { $0.createdAt < $1.createdAt }
        case .descending:
            return orders.sorted { $0.createdAt > $1.createdAt }
        }
    }

    var ordersCountByStatus: [OrderStatusEntity: Int] {
        Dictionary(grouping: orders, by: { $0.status })
            .mapValues { $0.count }
    }

    var statusCountsSorted: [(status: OrderStatusEntity, count: Int)] {
        OrderStatusEntity.allCases.map { status in
            (status, ordersCountByStatus[status] ?? 0)
        }
    }
}

@Observable
final class OrdersListViewModel {
    var bindingData = OrdersListModel.BindingData()
    private(set) var orders: [OrderModel] = []
    private(set) var updatedStatuses: [String: OrderStatusEntity] = [:]
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProviderImpl
    @ObservationIgnored
    private var coordinator: Coordinator!

    init(networkManager: NetworkManager, imageProvider: ImageLoaderProviderImpl) {
        self.networkManager = networkManager
        self.imageProvider = imageProvider
    }

    func setCoordinator(_ coord: Coordinator) {
        coordinator = coord
    }
}

// MARK: - Network

extension OrdersListViewModel {

    func fetchOrders() {
        fetchWithLoading { [weak self] in
            guard let self else { return }
            let entities = try await networkManager.orderService.fetchAllOrders()
            orders = entities.map(OrderModel.init(from:))
        }
    }

    func updateOrderStatus(orderID: String, newStatus: OrderStatusEntity) {
        Task { @MainActor in
            do {
                try await networkManager.orderService.updateOrderStatus(orderID: orderID, newStatus: newStatus)
            } catch {
                bindingData.alert = AlertModel(content: error.readableGRPCContent, isShown: true)
            }
        }
    }

}

// MARK: - Actions

extension OrdersListViewModel {

    func didTapSave() {
        bindingData.saveButtonIsLoading = true

        Task { @MainActor in
            bindingData.saveButtonIsLoading = true

            do {
                try await withThrowingTaskGroup(of: Void.self) { [weak self] group in
                    guard let self = self else { return }

                    for (orderID, newStatus) in updatedStatuses {
                        group.addTask {
                            try await self.networkManager.orderService.updateOrderStatus(orderID: orderID, newStatus: newStatus)
                        }
                    }

                    try await group.waitForAll()
                }

                AlertManager.shared.showAlert(title: "Успешно", message: "Статусы заказов обновлены")

                // Обновляем локально статусы заказов
                for (updatedStatusID, newStatus) in updatedStatuses {
                    guard let index = orders.firstIndex(where: { $0.id == updatedStatusID }) else {
                        continue
                    }
                    orders[index].status = newStatus
                }

            } catch {
                bindingData.alert = .init(content: error.readableGRPCContent, isShown: true)
            }

            bindingData.saveButtonIsLoading = false
        }
    }

    func didSelectOrderCell(orderID: String) {
        guard let order = orders.first(where: { $0.id == orderID }) else {
            return
        }

        coordinator.addScreen(OrdersListModel.Screens.order(order))
    }
    
}

// MARK: - Configure

extension OrdersListViewModel {

    func configureSaveButton() -> TLButton.Configuration {
        .init(title: "SAVE", kind: bindingData.saveButtonIsLoading ? .loading : .default)
    }

    func assembleOrderView(order: OrderModel) -> OrderDetailView {
        OrderDetailAssembler.assemble(
            order: order,
            networkManager: networkManager,
            imageProvider: imageProvider
        )
    }

    func bindingForStatus(of order: OrderModel) -> Binding<OrderStatusEntity> {
        Binding<OrderStatusEntity>(
            get: { [weak self] in
                self?.updatedStatuses[order.id] ?? order.status
            },
            set: { [weak self] newStatus in
                guard let self else { return }

                if newStatus != order.status {
                    updatedStatuses[order.id] = newStatus
                } else {
                    updatedStatuses.removeValue(forKey: order.id)
                }
            }
        )
    }

}

// MARK: - Helpers

private extension OrdersListViewModel {

    func fetchWithLoading(perform: @escaping () async throws -> Void) {
        bindingData.state = .loading

        Task { @MainActor in
            do {
                try await perform()
            } catch {
                bindingData.alert = AlertModel(content: error.readableGRPCContent, isShown: true)
            }

            bindingData.state = .finished
        }
    }

}
