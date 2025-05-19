//
//  CakesListProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import DesignSystem
import Core

// MARK: - View Model

protocol CakesListDisplayData {
    var bindingData: CakesListModel.BindingData { get }
    var sections: [CakesListModel.SectionKind: [CakeModel]] { get }
}

protocol CakesListViewModelInput {
    // MARK: Network
    func fetchData()
    // MARK: Configuration
    func configureErrorView(content: AlertContent) -> TLErrorView.Configuration
    func configureProductCard(model: CakeModel) -> TLProductCard.Configuration
    func configureShimmeringProductCard() -> TLProductCard.Configuration
    // MARK: Assembler
    func assemblyTagsView(cakes: [CakeModel]) -> ProductsGridView
    // MARK: Actions
    func didTapCell(model: CakeModel)
    func didTapSectionAllButton(sectionKind: CakesListModel.SectionKind)
    func didTapLikeButton(model: CakeModel, isSelected: Bool)
    // MARK: Setters
    func setEnvironmentObjects(coordinator: Coordinator)
}
