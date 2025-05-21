//
//  NotificationsListProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

protocol NotificationsListDisplayLogic: NotificationsListViewModelInput {
    var uiProperties: NotificationsListModel.UIProperties { get set }
    var notifications: [NotificationEntity] { get }
}

protocol NotificationsListViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func fetchNotifications()
    func didTapReloadButton()
    func subscribe()

    func assemblyOrderView(with notification: NotificationEntity, orderEntity: OrderEntity) -> OrderDetailsView
    func configureNotificationCell(for notification: NotificationEntity) -> TLNotificationCell.Configuration

    func didTapNotificationCell(with notification: NotificationEntity)
    func didDeleteNotification(id: String)
}

protocol NotificationsListViewModelOutput {
}
