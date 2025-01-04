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

    init(
        delay: TimeInterval = 0,
        notifications: [NotificationsListModel.NotificationModel]? = nil
    ) {
        self.delay = delay
        self.notifications = notifications ?? []
    }

    func setEnvironmentObjects(coordinator: Coordinator) {}
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
    }

    func didDeleteNotification(id: String) {
        print("[DEBUG]: \(#function)")
    }

    func configureNotificationCell(for notification: NotificationsListModel.NotificationModel) -> TLNotificationCell.Configuration {
        .init(notification: notification)
    }
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
                userID: "2",
                sellerID: "1",
                productID: String($0 + 1)
            )
        }

    }
}

#endif
