//
//  ChatAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 16.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class ChatAssembler {
    static func assemble(
        currentUser: UserModel,
        interlocutor: UserModel,
        chatProvider: ChatService
    ) -> ChatView {
        let viewModel = ChatViewModel(
            currentUser: currentUser,
            interlocutor: interlocutor,
            chatProvider: chatProvider
        )
        return ChatView(viewModel: viewModel)
    }
}
