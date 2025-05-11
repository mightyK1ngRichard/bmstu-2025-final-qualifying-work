//
//  CreateProductProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import DesignSystem

protocol CreateProductDisplayLogic {
    var uiProperties: CreateProductModel.UIProperties { get set }
}

protocol CreateProductViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func didCloseProductInfoSreen()
    func didTapCloseFillingCategoriesScreen()
    func didCloseProductImagesScreen()
    func didCloseResultScreen()
    func didTapCreateProduct()
    func didTapCancelProduct()
    func didTapDeleteProduct()
    func didTapBackScreen()

    func assemblyFillingsAndCategoriesView() -> AddFillingsAndCategoriesView
    func assembleCreateCakeInfoView() -> CreateCakeInfoView
    func assemblyAddProductImages() -> AddProductImages
    func assemblyProductResultScreen() -> ProductResultScreen

    func configureTLProductDescriptionConfiguration() -> TLProductDescriptionView.Configuration
}
