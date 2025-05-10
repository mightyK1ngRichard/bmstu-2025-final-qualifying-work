//
//  NotificationsListViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Observation
import NetworkAPI
import Combine

@Observable
final class NotificationsListViewModel: NotificationsListDisplayLogic, NotificationsListViewModelOutput {
    var uiProperties = NotificationsListModel.UIProperties()
    private(set) var notifications: [NotificationEntity] = []
    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private let orderService: OrderService
    @ObservationIgnored
    private let notificationService: NotificationService
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private var cancallables: Set<AnyCancellable> = []

    init(
        notificationService: NotificationService,
        orderService: OrderService,
        cakeService: CakeService,
        imageProvider: ImageLoaderProvider
    ) {
        self.orderService = orderService
        self.notificationService = notificationService
        self.cakeService = cakeService
        self.imageProvider = imageProvider
    }

    func subscribe() {
        notificationService.notificationPublisher
            .sink { [weak self] entity in
                Task { @MainActor in
                    self?.notifications.insert(entity, at: 0)
                }
            }
            .store(in: &cancallables)
    }
}

extension NotificationsListViewModel {
    func fetchNotifications() {
        notificationService.startStreamingNotifications()

        uiProperties.screenState = .loading
        Task { @MainActor in
            do {
                notifications = try await notificationService.getNotifications()
                uiProperties.screenState = .finished
            } catch {
                uiProperties.screenState = .error(content: error.readableGRPCContent)
            }
        }
    }
}

extension NotificationsListViewModel {

    func didTapNotificationCell(with notification: NotificationEntity) {
        if notification.notificationKind == .orderUpdate, let orderID = notification.orderID {
            Task { @MainActor in
                do {
                    let orderEntity = try await orderService.fetchOrderByID(orderID: orderID)
                    coordinator?.addScreen(NotificationsListModel.Screens.order(notification, orderEntity))
                }
            }
        }
    }

    func didDeleteNotification(id: String) {
        Task {
            try await notificationService.deleteNotification(notificationID: id)
        }

        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications.remove(at: index)
    }

    func didTapReloadButton() {
        fetchNotifications()
    }

    func assemblyOrderView(with notification: NotificationEntity, orderEntity: OrderEntity) -> OrderDetailsView {
        OrderDetailsAssemler.assemble(
            orderEntity: orderEntity,
            cakeService: cakeService,
            imageProvider: imageProvider
        )
    }

    func configureNotificationCell(for notification: NotificationEntity) -> TLNotificationCell.Configuration {
        .init(notification: notification)
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

}
