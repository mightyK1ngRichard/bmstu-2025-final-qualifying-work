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
        sectionKind: ProductsGridModel.SectionKind,
        cakeService: CakeService
    ) -> ProductsGridView {
        let viewModel = ProductsGridViewModel(cakes: cakes, sectionKind: sectionKind, cakeService: cakeService)
        return ProductsGridView(viewModel: viewModel)
    }
}
