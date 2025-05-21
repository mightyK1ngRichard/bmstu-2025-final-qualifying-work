//
//  CakesListAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 18.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI

@MainActor
final class CakesListAssembler {
    static func assemble(
        cakeService: CakeService,
        imageProvider: ImageLoaderProvider
    ) -> CakesListView {
        let viewModel = CakesListViewModel(
            cakeService: cakeService,
            imageProvider: imageProvider
        )
        return CakesListView(viewModel: viewModel)
    }
}
