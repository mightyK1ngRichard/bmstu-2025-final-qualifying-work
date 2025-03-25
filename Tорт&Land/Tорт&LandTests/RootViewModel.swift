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
        cakeService: StubGrpcCakeServiceImpl(),
        imageProvider: ImageLoaderProviderImpl()
    )

    @Test
    func mergeCakes() async throws {
        var expectedCakes = StubData.cakes()

        // Добавляем первые торты
        let cakes = Array(expectedCakes[0..<2])
        viewModel.setCakes(cakes)
        #expect(viewModel.cakes == cakes)

        // Добавляем ещё один торт
        let newCake = [expectedCakes[2]]
        viewModel.setCakes(newCake)
        #expect(viewModel.cakes == expectedCakes)

        // Добавляем торт с изменённым полем и уже существующий торт
        var updatedCake = expectedCakes[0]
        updatedCake.previewImageState = .loading
        let existedCake = expectedCakes[1]
        viewModel.setCakes([
            updatedCake,
            existedCake
        ])
        // В ожидаемых данных тоже меняем это поле
        expectedCakes[0].previewImageState = .loading
        #expect(viewModel.cakes == expectedCakes)
    }

}

extension RootViewModelTests {
    enum StubData {
        static func user() -> UserModel {
            UserModel(
                id: "1",
                name: "King",
                mail: "dimapermyakov55@gmail.com",
                avatarImage: .empty,
                headerImage: .empty,
                cakes: []
            )
        }

        static func cakes() -> [CakeModel] {
            let stubUser = user()

            return [
                CakeModel(
                    id: "1",
                    previewImageState: .fetched(.uiImage(.cake1)),
                    thumbnails: [],
                    cakeName: "Test cake name #1",
                    price: 1100,
                    rating: 3,
                    isSelected: true,
                    description: "Test description #1",
                    establishmentDate: Date(timeIntervalSince1970: 1672531199).description,
                    similarCakes: [],
                    comments: [],
                    categories: [],
                    fillings: [],
                    seller: stubUser
                ),
                CakeModel(
                    id: "2",
                    previewImageState: .fetched(.uiImage(.cake1)),
                    thumbnails: [],
                    cakeName: "Test cake name #2",
                    price: 1200,
                    rating: 4,
                    isSelected: false,
                    description: "Test description #2",
                    establishmentDate: Date(timeIntervalSince1970: 1672531199).description,
                    similarCakes: [],
                    comments: [],
                    categories: [],
                    fillings: [],
                    seller: stubUser
                ),
                CakeModel(
                    id: "3",
                    previewImageState: .fetched(.uiImage(.cake1)),
                    thumbnails: [],
                    cakeName: "Test cake name #3",
                    price: 1300,
                    rating: 5,
                    isSelected: true,
                    description: "Test description #3",
                    establishmentDate: Date(timeIntervalSince1970: 1672531199).description,
                    similarCakes: [],
                    comments: [],
                    categories: [],
                    fillings: [],
                    seller: stubUser
                )
            ]
        }
    }
}
