//
//  ProductsGridViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import UIKit
import NetworkAPI
import Observation
import DesignSystem

@Observable
final class ProductsGridViewModelMock: ProductsGridDisplayData, ProductsGridViewModelInput {
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
    private(set) var cakes: [CakeModel]
    private(set) var colors: [ProductsGridModel.ColorCell] = []
    private(set) var sectionKind: ProductsGridModel.SectionKind
    private(set) var selectedColors: Set<String> = []
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let cakeService: CakeService
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService

    init(
        cakes: [CakeModel] = MockData.cakes,
        sectionKind: ProductsGridModel.SectionKind = .sales,
        cakeService: CakeService,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.cakes = cakes
        self.sectionKind = sectionKind
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

    func didTapProductCard(cake: CakeModel) {
        coordinator?.addScreen(RootModel.Screens.details(cake))
    }

    func didTapProductLikeButton(cake: CakeModel, isSelected: Bool) {}

    func configureProductCard(cake: CakeModel) -> TLProductCard.Configuration {
        cake.configureProductCard(priceFormatter: priceFormatter)
    }

    func didTapFilterButton() {
        uiProperties.bottomSheetKind = .filter
        uiProperties.showFilterLoader = true
        Task { @MainActor in
            let hexStrings = try await cakeService.fetchColors()
            colors = hexStrings.compactMap {
                guard let uiColor = UIColor(hexString: $0, alpha: 1) else {
                    return nil
                }
                return .init(hex: $0, uiColor: uiColor)
            }
            uiProperties.showFilterLoader = false
            uiProperties.showBottomSheet = true
        }
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

    func cellIsSelected(for cell: ProductsGridModel.ColorCell) -> Bool {
        selectedColors.contains(cell.hex)
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
