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
        case details(NotificationModel)
    }

    struct NotificationModel: Identifiable, Hashable {
        let id: String
        var title: String
        var text: String?
        var date: String
        var sellerID: String
        var cakeID: String?
    }
}

extension NotificationsListModel.NotificationModel {
    init(from model: NotificationEntity) {
        self = .init(
            id: model.id,
            title: model.title,
            text: model.message,
            date: model.createdAt.formatted(.dateTime.year().month(.wide).day().hour().minute()),
            sellerID: model.senderID,
            cakeID: model.cakeID
        )
    }
}
