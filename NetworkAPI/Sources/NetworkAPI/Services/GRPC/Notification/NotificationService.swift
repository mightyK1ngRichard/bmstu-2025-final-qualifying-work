//
//  NotificationService.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 04.05.2025.
//

import Foundation
import GRPC
import NIO
import Combine
import SwiftProtobuf

public protocol NotificationService: Sendable {
    var notificationPublisher: PassthroughSubject<NotificationEntity, Never> { get }
    func getNotifications() async throws -> [NotificationEntity]
    func startStreamingNotifications()
    func sendNotification(req: NotificationServiceModel.SendNotification.Request) async throws -> NotificationEntity
    func deleteNotification(notificationID: String) async throws
    func closeConnection()
}

public final class NotificationServiceImpl: NotificationService, @unchecked Sendable {
    public let notificationPublisher = PassthroughSubject<NotificationEntity, Never>()
    private let client: Notification_NotificationServiceAsyncClientProtocol
    private let channel: GRPCChannel
    private let networkService: NetworkService
    private let authService: AuthService

    public init(
        configuration: GRPCHostPortConfiguration,
        authService: AuthService,
        networkService: NetworkService
    ) {
        do {
            let channel = try ConfigProvider.makeConection(
                host: configuration.hostName,
                port: configuration.port,
                numberOfThreads: 4
            )
            self.client = Notification_NotificationServiceAsyncClient(channel: channel)
            self.channel = channel
            self.authService = authService
            self.networkService = networkService
        } catch {
            #if DEBUG
            fatalError("Ошибка подключения к notification grpc серверу: \(error)")
            #else
            Logger.log(kind: .error, "Ошибка подключения к notification grpc серверу: \(error)")
            assertionFailure("Ошибка подключения к notification grpc серверу: \(error)")
            fatalError("Ошибка подключения к grpc серверу профиля: \(error)")
            #endif
        }
    }
}

public extension NotificationServiceImpl {

    func deleteNotification(notificationID: String) async throws {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Notification_DeleteNotificationReq.with {
            $0.notificationID = notificationID
        }

        return try await networkService.performAndLog(
            call: client.deleteNotification,
            with: request,
            mapping: { _ in }
        )
    }

    func sendNotification(req: NotificationServiceModel.SendNotification.Request) async throws -> NotificationEntity {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let request = Notification_CreateNotificationRequest.with {
            $0.kind = req.notificationKind.toProto
            $0.title = req.title
            $0.message = req.message
            $0.recipientID = req.recipientID

            if let orderID = req.orderID {
                $0.orderID = orderID
            }
        }

        return try await networkService.performAndLog(
            call: client.createNotification,
            with: request,
            mapping: { NotificationEntity(from: $0.notification) }
        )
    }

    func getNotifications() async throws -> [NotificationEntity] {
        try await networkService.maybeRefreshAccessToken(using: authService)

        let req = Google_Protobuf_Empty()

        return try await networkService.performAndLog(
            call: client.getNotifications,
            with: req,
            mapping: { $0.notifications.map(NotificationEntity.init(from:)) }
        )
    }

    func startStreamingNotifications() {
        Task {
            try await networkService.maybeRefreshAccessToken(using: authService)

            do {
                var options = networkService.callOptions
                options.timeLimit = .none
                let stream = client.streamNotifications(.init(), callOptions: options)
                for try await response in stream {
                    notificationPublisher.send(NotificationEntity(from: response.notification))
                }
            } catch {
                print("🔴 Ошибка в стриме уведомлений: \(error)")
            }
        }
    }

    func closeConnection() {
        do {
            try channel.close().wait()
        } catch {
            Logger.log(kind: .error, error)
        }
    }

}
