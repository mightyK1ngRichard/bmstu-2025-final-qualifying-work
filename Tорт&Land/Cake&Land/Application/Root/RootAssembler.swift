//
//  RootAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import Core

final class RootAssembler {
    @MainActor
    static func assemble(startScreenControl: StartScreenControl) -> RootView {
        let networkService = NetworkServiceImpl(
            modelName: SystemInfo.modelName,
            systemVersion: SystemInfo.appVersion,
            fingerprint: SystemInfo.ios
        )
        let imageProvider = ImageLoaderProviderImpl()
        let networkManager = NetworkManager(networkService: networkService)

        if networkService.refreshToken == nil {
            startScreenControl.update(with: .auth)
        }

        let viewModel = RootViewModel(
            networkManager: networkManager,
            imageProvider: imageProvider,
            startScreenControl: startScreenControl
        )
        
        return RootView(viewModel: viewModel)
    }
}
