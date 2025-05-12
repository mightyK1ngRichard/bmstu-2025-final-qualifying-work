//
//  RootAssembler.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

@MainActor
final class RootAssembler {
    static func assemble() -> RootView {
        let networkManager = NetworkManager()
        let imageProvider = ImageLoaderProviderImpl()
        let viewModel = RootViewModel(networkManager: networkManager, imageProvider: imageProvider)

        return RootView(viewModel: viewModel)
    }
}
