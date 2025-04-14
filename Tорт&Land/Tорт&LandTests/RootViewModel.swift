//
//  RootViewModel.swift
//  Tорт&LandTests
//
//  Created by Dmitriy Permyakov on 26.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Testing
import Foundation
@testable import Tорт_Land

struct RootViewModelTests {
    let viewModel = RootViewModel(
        authService: StubGrpcAuthService(),
        cakeService: StubGrpcCakeServiceImpl(),
        profileService: StubProfileGrpcServiceImpl(),
        imageProvider: ImageLoaderProviderImpl(),
        startScreenControl: StartScreenControl()
    )

    @Test
    func mergeCakes() async throws {
        let expectedCakes = (1...3).map {
            ModelsMockProvider.generateCakeEntity(id: $0)
        }

        // Добавляем первые торты
        let cakes = Array(expectedCakes[0..<2])
        viewModel.setCakes(cakes)
        #expect(viewModel.cakes == cakes)

        // Добавляем ещё один торт
        let newCake = [expectedCakes[2]]
        viewModel.setCakes(newCake)
        #expect(viewModel.cakes == expectedCakes)

        // Добавляем торт с изменённым полем и уже существующий торт
        let updatedCake = expectedCakes[0]
        let existedCake = expectedCakes[1]
        viewModel.setCakes([
            updatedCake,
            existedCake
        ])
        // В ожидаемых данных тоже меняем это поле
        #expect(viewModel.cakes == expectedCakes)
    }

}
