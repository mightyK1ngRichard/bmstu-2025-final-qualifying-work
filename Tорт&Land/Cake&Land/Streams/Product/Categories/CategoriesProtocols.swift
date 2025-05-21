//
//  CategoriesProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftData

protocol CategoriesDisplayLogic: CategoriesViewModelInput {
    var uiProperties: CategoriesModel.UIProperties { get set }
    var tabs: [CategoriesModel.Tab] { get }
    var sections: [CategoriesModel.Tab: [CategoryCardModel]] { get }
}

protocol CategoriesViewModelInput {
    func onAppear()
    func setEnvironmentObjects(coordinator: Coordinator, modelContext: ModelContext)

    func filterData(categories: [CategoryCardModel]) -> [CategoryCardModel]
    func didTapTab(tab: CategoriesModel.Tab)
    func didTapSearchToggle()
    func didTapMemoryCakes()
    func didTapLoadSavedData()
    func didTapSectionCell(section: CategoryCardModel, fromMemory: Bool)
    func didUpdateSelectedTag(section: CategoriesModel.Tab)

    func assemlyCakesCategoryView(cakes: [CakeModel]) -> ProductsGridView
}
