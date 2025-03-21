//
//  ProductsGridViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class ProductsGridViewModelMock: ProductsGridDisplayData & ProductsGridViewModelInput {
    var uiProperties = ProductsGridModel.UIProperties()
    private(set) var cakes: [CakeModel]
    private(set) var sectionKind: ProductsGridModel.SectionKind
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        cakes: [CakeModel] = MockData.cakes,
        sectionKind: ProductsGridModel.SectionKind = .sales
    ) {
        self.cakes = cakes
        self.sectionKind = sectionKind
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func didTapProductCard(cake: CakeModel) {
        coordinator?.addScreen(RootModel.Screens.details(cake))
    }

    func didTapProductLikeButton(cake: CakeModel, isSelected: Bool) {}

    func configureProductCard(cake: CakeModel) -> TLProductCard.Configuration {
        return cake.configureProductCard()
    }
}

// MARK: - Constants

private extension ProductsGridViewModelMock {
    enum MockData {
        static let cakes = (1...40).map {
            CommonMockData.generateMockCakeModel(id: $0)
        }
    }
}

#endif
