//
//  NotificationDetailModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum NotificationDetailModel {}

extension NotificationDetailModel {
    struct UIProperties: Hashable {
    }

    struct OrderData: Hashable {
        var kind: Kind
        var cake: CakeModel
        var notification: NotificationsListModel.NotificationModel
        var deliveryAddress: String?
    }
}

extension NotificationDetailModel.OrderData {
    /// Вид уведомления
    enum Kind: Hashable {
        /// Покупака товара (Вы покупатель)
        case purchase(UserModel)
        /// Продажа товара (Вы продавец)
        case sale(UserModel)
    }
}
