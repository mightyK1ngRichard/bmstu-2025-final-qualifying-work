//
//  CakeListAssembler.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 14.05.2025.
//

final class CakeListAssembler {
    static func assemble(networkManager: NetworkManager, imageProvider: ImageLoaderProviderImpl) -> CakeListView {
        let viewModel = CakeListViewModel(networkManager: networkManager, imageProvider: imageProvider)
        return CakeListView(viewModel: viewModel)
    }
}
