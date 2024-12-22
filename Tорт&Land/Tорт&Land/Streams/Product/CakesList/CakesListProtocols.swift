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
    func configureProductCard(model: CakesListModel.CakeModel, section: CakesListModel.Section) -> TLProductCard.Configuration
    func configureShimmeringProductCard() -> TLProductCard.Configuration
    func didTapCell(model: CakesListModel.CakeModel)
}

protocol CakesListViewModelOutput {
    func didTapNewsAllButton(_ configurations: [CakesListModel.CakeModel])
    func didTapSalesAllButton(_ configurations: [CakesListModel.CakeModel])
    func didTapLikeButton(model: CakesListModel.CakeModel, isSelected: Bool)
}
