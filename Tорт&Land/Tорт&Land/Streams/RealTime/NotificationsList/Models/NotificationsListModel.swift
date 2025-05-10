//
//  NotificationsListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

enum NotificationsListModel {}

extension NotificationsListModel {
    struct UIProperties: Hashable {
        var screenState: ScreenState = .initial
    }

    enum Screens: Hashable {
        case order(NotificationEntity, OrderEntity)
    }
}
