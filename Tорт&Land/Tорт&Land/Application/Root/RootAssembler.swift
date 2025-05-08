//
//  RootAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class RootAssembler {
    @MainActor
    static func assemble(startScreenControl: StartScreenControl) -> RootView {
        let networkService = NetworkServiceImpl()
        let imageProvider = ImageLoaderProviderImpl()
        let authService = AuthGrpcServiceImpl(
            configuration: AppHosts.auth,
            networkService: networkService
        )
        let cakeService = CakeGrpcServiceImpl(
            configuration: AppHosts.cake,
            authService: authService,
            networkService: networkService
        )
        let profileService = ProfileGrpcServiceImpl(
            configuration: AppHosts.profile,
            authService: authService,
            networkService: networkService
        )
        let chatService = ChatServiceImpl(
            configuration: AppHosts.chat,
            authService: authService,
            networkService: networkService
        )
        let reviewsService = ReviewsGrpcServiceImpl(
            configuration: AppHosts.reviews,
            authService: authService,
            networkService: networkService
        )
        let orderService = OrderGrpcServiceImpl(
            configuration: AppHosts.order,
            authService: authService,
            networkService: networkService
        )
        let notificationService = NotificationServiceImpl(
            configuration: AppHosts.notification,
            authService: authService,
            networkService: networkService
        )

        if networkService.refreshToken == nil {
            startScreenControl.update(with: .auth)
        }

        let viewModel = RootViewModel(
            authService: authService,
            cakeService: cakeService,
            reviewsService: reviewsService,
            chatProvider: chatService,
            profileService: profileService,
            orderProvider: orderService,
            notificationService: notificationService,
            imageProvider: imageProvider,
            startScreenControl: startScreenControl
        )
        
        return RootView(viewModel: viewModel)
    }

    static func assembleMock() -> RootView {
        let viewModel = RootViewModelMock()
        return RootView(viewModel: viewModel)
    }
}
