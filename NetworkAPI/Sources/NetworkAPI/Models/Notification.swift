//
//  Notification.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 04.05.2025.
//

import Foundation

public struct NotificationEntity: Sendable, Hashable {
    public let id: String
    public let title: String
    public let message: String
    public let createdAt: Date
    public let notificationKind: NotificationKind
    public let orderID: String?
    public let senderID: String
}

// MARK: - NotificationKind

public enum NotificationKind: Sendable, Hashable {
    /// Личное сообщение
    case message
    /// Отзыв
    case feedback
    /// Обновление по заказу
    case orderUpdate
    /// Системное уведомление
    case system
    /// Рекламное уведомление
    case promo
}

extension NotificationKind {
    var toProto: Notification_NotificationKind {
        switch self {
        case .message:
            return .message
        case .feedback:
            return .feedback
        case .orderUpdate:
            return .orderUpdate
        case .system:
            return .system
        case .promo:
            return .promo
        }
    }

    init(from model: Notification_NotificationKind) {
        switch model {
        case .message:
            self = .message
        case .feedback:
            self = .feedback
        case .orderUpdate:
            self = .orderUpdate
        case .system:
            self = .system
        case .promo:
            self = .promo
        case .UNRECOGNIZED:
            self = .system
        @unknown default:
            self = .system
        }
    }
}

// MARK: - Init

extension NotificationEntity {
    init(from model: Notification_Notification) {
        self = .init(
            id: model.id,
            title: model.title,
            message: model.message,
            createdAt: model.createdAt.date,
            notificationKind: NotificationKind(from: model.kind),
            orderID: model.hasOrderID ? model.orderID : nil,
            senderID: model.senderID
        )
    }
}
