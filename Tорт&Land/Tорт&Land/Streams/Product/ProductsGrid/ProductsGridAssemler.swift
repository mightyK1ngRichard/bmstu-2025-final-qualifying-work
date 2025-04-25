//
//  ProductsGridAssemler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

final class ProductsGridAssemler {
    static func assembly(cakes: [CakeModel], sectionKind: ProductsGridModel.SectionKind) -> ProductsGridView {
        let viewModel = ProductsGridViewModel(cakes: cakes, sectionKind: sectionKind)
        return ProductsGridView(viewModel: viewModel)
    }
}
