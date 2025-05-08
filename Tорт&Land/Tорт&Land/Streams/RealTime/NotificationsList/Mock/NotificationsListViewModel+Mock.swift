//
//  NotificationsListViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class NotificationsListViewModelMock: NotificationsListDisplayLogic & NotificationsListViewModelOutput {
    var uiProperties = NotificationsListModel.UIProperties()
    @ObservationIgnored
    var delay: TimeInterval
    private(set) var notifications: [NotificationsListModel.NotificationModel]
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        delay: TimeInterval = 0,
        notifications: [NotificationsListModel.NotificationModel]? = nil
    ) {
        self.delay = delay
        self.notifications = notifications ?? []
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension NotificationsListViewModelMock {
    func fetchNotifications() {
        uiProperties.screenState = .loading
        Task {
            try? await Task.sleep(for: .seconds(delay))
            await MainActor.run {
                notifications = MockData.mockNotifications
                uiProperties.screenState = .finished
            }
        }
    }
}

extension NotificationsListViewModelMock {
    func didTapNotificationCell(with notification: NotificationsListModel.NotificationModel) {
        print("[DEBUG]: \(#function)")
        coordinator?.addScreen(NotificationsListModel.Screens.details(notification))
    }

    func didDeleteNotification(id: String) {
        print("[DEBUG]: \(#function)")
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

    func subscribe() {}

    func didTapReloadButton() {}
}

// MARK: - Mock Data

private extension NotificationsListViewModelMock {
    enum MockData {
        static let mockNotifications: [NotificationsListModel.NotificationModel] = (1...15).map {
            .init(
                id: String($0),
                title: "Доставка \($0)",
                text: "Вас ожидает доставщик торта по номеру заказа #\($0)",
                date: Date().description.toCorrectDate,
                sellerID: "1",
                cakeID: String($0 + 1)
            )
        }

    }
}

#endif
