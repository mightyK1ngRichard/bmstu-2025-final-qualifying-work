//
//  CakesListProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation

protocol CakesListDisplayLogic: CakesListViewModelInput {
    var sections: [CakesListModel.Section] { get }
    var screenState: ScreenState { get }
}

protocol CakesListViewModelInput {
    func fetchData()
    func configureProductCard(model: CakeModel, section: CakesListModel.Section) -> TLProductCard.Configuration
    func configureShimmeringProductCard() -> TLProductCard.Configuration
    func assemblyTagsView(cakes: [CakeModel], sectionKind: ProductsGridModel.SectionKind) -> ProductsGridView
    func didTapCell(model: CakeModel)
    func setEnvironmentObjects(coordinator: Coordinator)
}

protocol CakesListViewModelOutput {
    func didTapNewsAllButton(_ cakes: [CakeModel])
    func didTapSalesAllButton(_ cakes: [CakeModel])
    func didTapLikeButton(model: CakeModel, isSelected: Bool)
}
