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
        rootViewModel: RootViewModelOutput,
        cakeService: CakeService,
        imageProvider: ImageLoaderProvider
    ) -> CakesListView {
        let viewModel = CakesListViewModel(rootViewModel: rootViewModel)
        let interactor = CakesListInteractor(cakeService: cakeService, imageProvider: imageProvider)
        let presenter = CakesListPresenter()
        interactor.presenter = presenter
        viewModel.interactor = interactor
        presenter.viewModel = viewModel
        return CakesListView(viewModel: viewModel)
    }

    static func assembleMock() -> CakesListView {
        let viewModel = CakesListViewModelMock(delay: 3)
        return CakesListView(viewModel: viewModel)
    }
}
