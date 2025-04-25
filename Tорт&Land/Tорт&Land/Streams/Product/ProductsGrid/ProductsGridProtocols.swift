//
//  ProductsGridProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol ProductsGridDisplayData {
    var uiProperties: ProductsGridModel.UIProperties { get set }
    var cakes: [CakeModel] { get }
    var sectionKind: ProductsGridModel.SectionKind { get }
}

protocol ProductsGridViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func configureProductCard(cake: CakeModel) -> TLProductCard.Configuration
    func didTapProductCard(cake: CakeModel)
    func didTapProductLikeButton(cake: CakeModel, isSelected: Bool)
}

@MainActor
protocol ProductsGridDisplayLogic {
}
