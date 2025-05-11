//
//  CategoriesProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol CategoriesDisplayLogic: CategoriesViewModelInput {
    var uiProperties: CategoriesModel.UIProperties { get set }
    var tabs: [CategoriesModel.Tab] { get }
    var sections: [CategoriesModel.Tab: [CategoryCardModel]] { get }
}

protocol CategoriesViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func filterData(categories: [CategoryCardModel]) -> [CategoryCardModel]
}

protocol CategoriesViewModelOutput {
    func onAppear()
    func didTapTab(tab: CategoriesModel.Tab)
    func didTapSearchToggle()
    func didTapSectionCell(section: CategoryCardModel)
    func didUpdateSelectedTag(section: CategoriesModel.Tab)
    func assemlyCakesCategoryView(cakes: [CakeModel]) -> ProductsGridView
}
