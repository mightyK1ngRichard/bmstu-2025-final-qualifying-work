//
//  NetworkManager.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import NetworkAPI
import Core

@MainActor
final class NetworkManager {
    let authService: AuthService
    let cakeService: CakeService
    let orderService: OrderService
    let profileService: ProfileService
    let chatService: ChatService
    let notificationService: NotificationService
    let reviewsService: ReviewsService

    init() {
        let networkService = NetworkServiceImpl(
            modelName: SystemInfo.modelName,
            systemVersion: SystemInfo.appVersion,
            fingerprint: SystemInfo.ios
        )

        authService = AuthGrpcServiceImpl(
            configuration: AppHosts.auth,
            networkService: networkService
        )

        cakeService = CakeGrpcServiceImpl(
            configuration: AppHosts.cake,
            authService: authService,
            networkService: networkService
        )

        orderService = OrderGrpcServiceImpl(
            configuration: AppHosts.order,
            authService: authService,
            networkService: networkService
        )

        profileService = ProfileGrpcServiceImpl(
            configuration: AppHosts.profile,
            authService: authService,
            networkService: networkService
        )

        chatService = ChatServiceImpl(
            configuration: AppHosts.chat,
            authService: authService,
            networkService: networkService
        )

        notificationService = NotificationServiceImpl(
            configuration: AppHosts.notification,
            authService: authService,
            networkService: networkService
        )

        reviewsService = ReviewsGrpcServiceImpl(
            configuration: AppHosts.reviews,
            authService: authService,
            networkService: networkService
        )
    }

    func closeConnections() {
        authService.closeConnection()
        cakeService.closeConnection()
        orderService.closeConnection()
        profileService.closeConnection()
        chatService.closeConnection()
        notificationService.closeConnection()
        reviewsService.closeConnection()
    }

    #if DEBUG
    init(mockRefreshToken: String) {
        let networkService = NetworkServiceImpl(
            modelName: SystemInfo.modelName,
            systemVersion: SystemInfo.appVersion,
            fingerprint: SystemInfo.ios
        )
        networkService.setRefreshToken(mockRefreshToken)

        authService = AuthGrpcServiceImpl(
            configuration: AppHosts.auth,
            networkService: networkService
        )

        cakeService = CakeGrpcServiceImpl(
            configuration: AppHosts.cake,
            authService: authService,
            networkService: networkService
        )

        orderService = OrderGrpcServiceImpl(
            configuration: AppHosts.order,
            authService: authService,
            networkService: networkService
        )

        profileService = ProfileGrpcServiceImpl(
            configuration: AppHosts.profile,
            authService: authService,
            networkService: networkService
        )

        chatService = ChatServiceImpl(
            configuration: AppHosts.chat,
            authService: authService,
            networkService: networkService
        )

        notificationService = NotificationServiceImpl(
            configuration: AppHosts.notification,
            authService: authService,
            networkService: networkService
        )

        reviewsService = ReviewsGrpcServiceImpl(
            configuration: AppHosts.reviews,
            authService: authService,
            networkService: networkService
        )
    }
    #endif
}
