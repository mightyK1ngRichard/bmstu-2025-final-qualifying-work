//
//  NotificationsListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum NotificationsListModel {}

extension NotificationsListModel {
    struct UIProperties: Hashable {
        var screenState: ScreenState = .initial
    }

    struct NotificationModel: Identifiable, Hashable {
        let id: String
        var title: String
        var text: String?
        var date: String
        var userID: String
        var sellerID: String
        var productID: String
    }
}
