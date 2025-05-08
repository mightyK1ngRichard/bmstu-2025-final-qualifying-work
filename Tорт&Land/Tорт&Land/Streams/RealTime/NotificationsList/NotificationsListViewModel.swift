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
final class NotificationsListViewModel: NotificationsListDisplayLogic & NotificationsListViewModelOutput {
    var uiProperties = NotificationsListModel.UIProperties()
    private(set) var notifications: [NotificationsListModel.NotificationModel] = []
    @ObservationIgnored
    var notificationService: NotificationService
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private var cancallables: Set<AnyCancellable> = []

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func subscribe() {
        notificationService.notificationPublisher
            .sink { [weak self] entity in
                Task { @MainActor in
                    self?.notifications.append(.init(from: entity))
                }
            }
            .store(in: &cancallables)
    }
}

extension NotificationsListViewModel {
    func fetchNotifications() {
        uiProperties.screenState = .loading
        Task { @MainActor in
            do {
                let entities = try await notificationService.getNotifications()
                notifications = entities.map(NotificationsListModel.NotificationModel.init(from:))
                uiProperties.screenState = .finished
            } catch {
                uiProperties.screenState = .error(message: error.readableGRPCMessage)
            }
        }
    }
}

extension NotificationsListViewModel {

    func didTapNotificationCell(with notification: NotificationsListModel.NotificationModel) {
        coordinator?.addScreen(NotificationsListModel.Screens.details(notification))
    }

    func didDeleteNotification(id: String) {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications.remove(at: index)
    }

    func didTapReloadButton() {
        fetchNotifications()
    }

    func configureNotificationCell(for notification: NotificationsListModel.NotificationModel) -> TLNotificationCell.Configuration {
        .init(notification: notification)
    }

    func assemblyNotificationDetails(with notification: NotificationsListModel.NotificationModel) -> NotificationDetailView {
        let orderData = NotificationDetailModel.OrderData(
            kind: .purchase(CommonMockData.generateMockUserModel(id: 1)),
            cake: CommonMockData.generateMockCakeModel(id: 1, withDiscount: true),
            notification: notification,
            deliveryAddress: nil
        )
        let viewModel = NotificationDetailViewModelMock(orderData: orderData)
        return NotificationDetailView(viewModel: viewModel)
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

}
