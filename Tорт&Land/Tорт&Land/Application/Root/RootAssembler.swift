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
            networkService: networkService
        )
        let profileService = ProfileGrpcServiceImpl(
            configuration: AppHosts.profile,
            authService: authService,
            networkService: networkService
        )

        if networkService.refreshToken == nil {
            startScreenControl.update(with: .auth)
        }

        let viewModel = RootViewModel(
            authService: authService,
            cakeService: cakeService,
            profileService: profileService,
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
