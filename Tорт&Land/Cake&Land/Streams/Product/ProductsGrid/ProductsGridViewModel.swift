//
//  ProductsGridViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import UIKit
import Foundation
import NetworkAPI
import DesignSystem

@Observable
final class ProductsGridViewModel: ProductsGridDisplayData & ProductsGridViewModelInput {
    var uiProperties = ProductsGridModel.UIProperties()
    var displayedCakes: [CakeModel] {
        let filteredCakes = cakes.filter { cake in
            // Проверка цены
            let isPriceValid = (cake.discountedPrice ?? cake.price) <= uiProperties.priceRange

            // Проверка цвета (если selectedColors не пуст)
            let hasMatchingColor = selectedColors.isEmpty || selectedColors.contains { color in
                cake.colorsHex.contains(color)
            }

            // Оба условия должны быть true
            return isPriceValid && hasMatchingColor
        }

        switch uiProperties.selectedSortMode {
        case .none:
            return filteredCakes
        case .priceAsc:
            return filteredCakes.sorted { ($0.discountedPrice ?? $0.price) < ($1.discountedPrice ?? $1.price) }
        case .priceDesc:
            return filteredCakes.sorted { ($0.discountedPrice ?? $0.price) > ($1.discountedPrice ?? $1.price) }
        case .dateNewest:
            return filteredCakes.sorted { $0.establishmentDate > $1.establishmentDate }
        case .dateOldest:
            return filteredCakes.sorted { $0.establishmentDate < $1.establishmentDate }
        }
    }
    private(set) var colors: [ProductsGridModel.ColorCell] = []
    private(set) var selectedColors: Set<String> = []
    private var cakes: [CakeModel] = []
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService

    init(
        cakes: [CakeModel],
        cakeService: CakeService,
        priceFormatter: PriceFormatterService
    ) {
        self.cakes = cakes
        self.cakeService = cakeService
        self.priceFormatter = priceFormatter

        let maxCake = cakes.max {
            ($0.discountedPrice ?? $0.price) < ($1.discountedPrice ?? $1.price)
        }
        uiProperties.maxPrice = maxCake?.discountedPrice ?? maxCake?.price ?? 1000
        uiProperties.priceRange = uiProperties.maxPrice
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func cellIsSelected(for cell: ProductsGridModel.ColorCell) -> Bool {
        selectedColors.contains(cell.hex)
    }

}

// MARK: - Actions

extension ProductsGridViewModel {

    func didTapFilterButton() {
        uiProperties.bottomSheetKind = .filter

        // Получаем все цвета тортов
        if colors.isEmpty {
            uiProperties.showFilterLoader = true
            var uniqueColors: Set<ProductsGridModel.ColorCell> = []
            uniqueColors.formUnion(
                cakes
                    .flatMap { $0.colorsHex }
                    .compactMap { hex -> ProductsGridModel.ColorCell? in
                        guard let uiColor = UIColor(hexString: hex, alpha: 1) else {
                            return nil
                        }
                        return .init(hex: hex, uiColor: uiColor)
                    }
            )
            colors = Array(uniqueColors)
            uiProperties.showFilterLoader = false
        }

        uiProperties.showBottomSheet = true
    }

    func didTapSortButton() {
        uiProperties.bottomSheetKind = .sort
        uiProperties.showBottomSheet = true
    }

    func didSelectedSortMode(mode: ProductsGridModel.SortMode) {
        uiProperties.selectedSortMode = mode
        uiProperties.showBottomSheet = false
    }

    func didTapColorCell(with colorCell: ProductsGridModel.ColorCell) {
        if selectedColors.contains(colorCell.hex) {
            selectedColors.remove(colorCell.hex)
        } else {
            selectedColors.insert(colorCell.hex)
        }
    }

    func didTapProductCard(cake: CakeModel) {
        coordinator?.addScreen(RootModel.Screens.details(cake))
    }

    func didTapProductLikeButton(cake: CakeModel, isSelected: Bool) {}

}

// MARK: - Configurations

extension ProductsGridViewModel {

    func configureProductCard(cake: CakeModel) -> TLProductCard.Configuration {
        cake.configureProductCard(priceFormatter: priceFormatter)
    }

}
