//
//  CakesListProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

// MARK: - View Model

protocol CakesListDisplayData {
    var bindingData: CakesListModel.BindingData { get }
}

protocol CakesListViewModelInput {
    func fetchData()
    func configureProductCard(model: CakeModel, section: CakesListModel.Section.Kind) -> TLProductCard.Configuration
    func configureShimmeringProductCard() -> TLProductCard.Configuration
    func assemblyTagsView(cakes: [CakeModel], sectionKind: ProductsGridModel.SectionKind) -> ProductsGridView
    func setEnvironmentObjects(coordinator: Coordinator)
    func didTapCell(model: CakeModel)
    func didTapAllButton(_ cakes: [CakeModel], section: ProductsGridModel.SectionKind)
    func didTapLikeButton(model: CakeModel, isSelected: Bool)
}

@MainActor
protocol CakesListDisplayLogic {
    func didFetchSections(with sections: [CakesListModel.Section])
    func showError(message: String)
    func updateCakeCellImage(cakeID: String, imageState: ImageState, with sectionKind: CakesListModel.Section.Kind)
}

// MARK: - Business Logic

protocol CakesListBusinessLogic {
    func fetchCakes()
}

// MARK: - Presentation

protocol CakesListPresenterInput {
    func didFetchCakes(result: Result<[CakesListModel.Section.Kind: [PreviewCakeEntity]], Error>) async
    func updateCakeCellImage(cakeID: String, imageState: ImageState, with sectionKind: CakesListModel.Section.Kind) async
}
