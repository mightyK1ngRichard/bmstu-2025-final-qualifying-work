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
    func configureErrorView(content: ErrorContent) -> TLErrorView.Configuration
}

@MainActor
protocol CakesListDisplayLogic: AnyObject {
    func didFetchSections(with sections: [CakesListModel.Section])
    func showError(content: ErrorContent)
    func updateCakeCellImage(cakeID: String, imageState: ImageState, with sectionKind: CakesListModel.Section.Kind)
    func addCakesToRootViewModel(_ cakes: [CakeEntity])
    func updateUserAvatarImage(imageState: ImageState, cakeID: String)
    func updateUserHeaderImage(imageState: ImageState, cakeID: String)
}

// MARK: - Business Logic

protocol CakesListBusinessLogic {
    func fetchCakes()
}

// MARK: - Presentation

protocol CakesListPresenterInput {
    func addCakesToRootViewModel(_ cakes: [CakeEntity]) async
    func didFetchCakes(result: Result<[CakesListModel.Section.Kind: [PreviewCakeEntity]], Error>) async
    func updateCakeCellImage(cakeID: String, imageState: ImageState, with sectionKind: CakesListModel.Section.Kind) async
    @MainActor
    func updateUserAvatarImage(imageState: ImageState, cakeID: String)
    @MainActor
    func updateUserHeaderImage(imageState: ImageState, cakeID: String)
}
