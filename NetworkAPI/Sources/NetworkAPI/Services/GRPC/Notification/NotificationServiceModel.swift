//
//  NotificationServiceModel.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 04.05.2025.
//

import Foundation

public enum NotificationServiceModel {
    public enum SendNotification {}
}

// MARK: - CreateCategory

public extension NotificationServiceModel.SendNotification {
    struct Request: Sendable {
        let title: String
        let message: String
        let recipientID: String
        let notificationKind: NotificationKind
        let cakeID: String?

        public init(
            title: String,
            message: String,
            recipientID: String,
            notificationKind: NotificationKind,
            cakeID: String?
        ) {
            self.title = title
            self.message = message
            self.recipientID = recipientID
            self.notificationKind = notificationKind
            self.cakeID = cakeID
        }
    }
}
