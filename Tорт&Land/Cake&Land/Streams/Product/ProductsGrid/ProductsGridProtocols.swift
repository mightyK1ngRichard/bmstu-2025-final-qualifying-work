//
//  ProductsGridProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import DesignSystem

protocol ProductsGridDisplayData {
    var uiProperties: ProductsGridModel.UIProperties { get set }
    var colors: [ProductsGridModel.ColorCell] { get }
    var displayedCakes: [CakeModel] { get }
}

protocol ProductsGridViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func configureProductCard(cake: CakeModel) -> TLProductCard.Configuration
    func didTapProductCard(cake: CakeModel)
    func didTapProductLikeButton(cake: CakeModel, isSelected: Bool)
    func didTapFilterButton()
    func didTapSortButton()
    func didSelectedSortMode(mode: ProductsGridModel.SortMode)
    func didTapColorCell(with: ProductsGridModel.ColorCell)
    func cellIsSelected(for: ProductsGridModel.ColorCell) -> Bool
}

@MainActor
protocol ProductsGridDisplayLogic {
}
