//
//  CreateProductAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class CreateProductAssembler {
    static func assemble(cakeProvider: CakeService, imageProvider: ImageLoaderProvider) -> CreateProductView {
        let viewModel = CreateProductViewModel(cakeProvider: cakeProvider, imageProvider: imageProvider)
        return CreateProductView(viewModel: viewModel)
    }
}
