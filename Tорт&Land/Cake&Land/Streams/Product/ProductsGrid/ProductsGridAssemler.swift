//
//  ProductsGridAssemler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class ProductsGridAssemler {
    static func assembly(
        cakes: [CakeModel],
        cakeService: CakeService,
        priceFormatter: PriceFormatterService = .shared
    ) -> ProductsGridView {
        let viewModel = ProductsGridViewModel(cakes: cakes, cakeService: cakeService, priceFormatter: priceFormatter)
        return ProductsGridView(viewModel: viewModel)
    }
}
