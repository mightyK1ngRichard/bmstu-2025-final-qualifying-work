//
//  ChatListAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 16.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class ChatListAssembler {
    static func assemble(currentUser: UserModel, imageProvider: ImageLoaderProvider, chatProvider: ChatService) -> ChatListView {
        let viewModel = ChatListViewModel(
            currentUser: currentUser,
            imageProvider: imageProvider,
            chatProvider: chatProvider
        )
        return ChatListView(viewModel: viewModel)
    }
}
