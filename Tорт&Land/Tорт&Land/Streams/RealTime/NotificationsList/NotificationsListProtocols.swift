//
//  NotificationsListProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol NotificationsListDisplayLogic: NotificationsListViewModelInput {
    var uiProperties: NotificationsListModel.UIProperties { get set }
    var notifications: [NotificationsListModel.NotificationModel] { get }
}

protocol NotificationsListViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func fetchNotifications()
    func didTapReloadButton()
    func subscribe()

    func configureNotificationCell(for notification: NotificationsListModel.NotificationModel) -> TLNotificationCell.Configuration
    func assemblyNotificationDetails(with notification: NotificationsListModel.NotificationModel) -> NotificationDetailView

    func didTapNotificationCell(with notification: NotificationsListModel.NotificationModel)
    func didDeleteNotification(id: String)
}

protocol NotificationsListViewModelOutput {
}
