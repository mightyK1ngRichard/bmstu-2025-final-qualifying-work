//
//  CakesListAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 18.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI

final class CakesListAssembler {
    @MainActor
    static func assemble() -> some View {
        let viewModel = CakesListViewModel()
        let cakeService = CakeGrpcServiceImpl(configuration: AppHosts.cake, networkService: NetworkServiceImpl())
        let imageProvider = ImageLoaderProviderImpl()
        let interactor = CakesListInteractor(cakeService: cakeService, imageProvider: imageProvider)
        let presenter = CakesListPresenter()
        interactor.presenter = presenter
        viewModel.interactor = interactor
        presenter.viewModel = viewModel
        return CakesListView(viewModel: viewModel)
    }
}
