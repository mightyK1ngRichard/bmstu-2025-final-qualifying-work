//
//  ProfileAssemler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 10.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class ProfileAssemler {
    static func assemble(
        user: UserModel?,
        imageProvider: ImageLoaderProvider,
        networkManager: NetworkManager,
        isCurrentUser: Bool,
        rootViewModel: RootViewModel
    ) -> ProfileView {
        let viewModel = ProfileViewModel(
            user: user,
            imageProvider: imageProvider,
            networkManager: networkManager,
            isCurrentUser: isCurrentUser,
            rootViewModel: rootViewModel
        )

        return ProfileView(viewModel: viewModel)
    }
}
