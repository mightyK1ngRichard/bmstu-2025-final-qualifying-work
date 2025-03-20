//
//  ProductsGridViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

@Observable
final class ProductsGridViewModel: ProductsGridDisplayData & ProductsGridViewModelInput {
    var uiProperties = ProductsGridModel.UIProperties()
    private(set) var cakes: [CakeModel]
    private(set) var sectionKind: ProductsGridModel.SectionKind
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        cakes: [CakeModel],
        sectionKind: ProductsGridModel.SectionKind
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
        cake.configureProductCard()
    }
}
