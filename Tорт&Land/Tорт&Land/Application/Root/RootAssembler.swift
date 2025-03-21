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
    static func assemble() -> RootView {
        let networkService = NetworkServiceImpl()
        let cakeService = CakeGrpcServiceImpl(
            configuration: AppHosts.cake,
            networkService: networkService
        )
        let viewModel = RootViewModel(cakeService: cakeService)
        return RootView(viewModel: viewModel)
    }

    static func assembleMock() -> RootView {
        let viewModel = RootViewModelMock()
        return RootView(viewModel: viewModel)
    }
}
