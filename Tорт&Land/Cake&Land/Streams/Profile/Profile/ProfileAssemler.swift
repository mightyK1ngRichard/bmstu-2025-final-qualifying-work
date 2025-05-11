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
        cakeProvider: CakeService,
        chatProvider: ChatService,
        profileService: ProfileService,
        authService: AuthService,
        orderService: OrderService,
        isCurrentUser: Bool,
        rootViewModel: RootViewModel
    ) -> ProfileView {
        let viewModel = ProfileViewModel(
            user: user,
            imageProvider: imageProvider,
            cakeProvider: cakeProvider,
            chatProvider: chatProvider,
            authService: authService,
            profileService: profileService,
            orderService: orderService,
            isCurrentUser: isCurrentUser,
            rootViewModel: rootViewModel
        )

        return ProfileView(viewModel: viewModel)
    }
}
