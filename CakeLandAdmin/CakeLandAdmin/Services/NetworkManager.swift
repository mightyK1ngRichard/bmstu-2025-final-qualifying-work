//
//  NetworkManager.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import NetworkAPI

@MainActor
final class NetworkManager {
    let authService: AuthService
    let cakeService: CakeService
    let orderService: OrderService
    let profileService: ProfileService

    init() {
        let networkService = NetworkServiceImpl(
            modelName: SystemInfo.modelIdentifier,
            systemVersion: SystemInfo.systemVersion,
            fingerprint: "macos"
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
    }
}
