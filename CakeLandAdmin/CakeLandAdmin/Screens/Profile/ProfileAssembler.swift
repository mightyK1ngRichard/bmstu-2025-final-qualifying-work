//
//  ProfileAssembler.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 15.05.2025.
//

final class ProfileAssembler {
    static func assemble(networkManager: NetworkManager, imageProvider: ImageLoaderProviderImpl) -> ProfileView {
        let viewModel = ProfileViewModel(networkManager: networkManager, imageProvider: imageProvider)
        return ProfileView(viewModel: viewModel)
    }
}
