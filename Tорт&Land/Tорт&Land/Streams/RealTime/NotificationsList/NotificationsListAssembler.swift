//
//  NotificationsListAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class NotificationsListAssembler {
    static func assemble(notificationService: NotificationService) -> NotificationsListView {
        let viewModel = NotificationsListViewModel(notificationService: notificationService)
        return NotificationsListView(viewModel: viewModel)
    }
}
