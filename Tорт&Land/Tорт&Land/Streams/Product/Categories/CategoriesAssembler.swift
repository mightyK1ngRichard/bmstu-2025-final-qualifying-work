//
//  CategoriesAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 14.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class CategoriesAssembler {
    static func assemble(cakeProvider: CakeGrpcService, imageProvider: ImageLoaderProvider) -> CategoriesView {
        let viewModel = CategoriesViewModel(cakeProvider: cakeProvider, imageProvider: imageProvider)
        let view = CategoriesView(viewModel: viewModel)
        return view
    }
}
