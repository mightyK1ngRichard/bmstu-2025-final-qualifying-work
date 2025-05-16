//
//  ChatListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

enum ChatListModel {}

extension ChatListModel {
    struct UIProperties: Hashable {
        var screenState: ScreenState = .initial
        var searchText = ""
    }

    enum Screens: Hashable {
        case chat(ChatCellModel)
    }

    struct ChatCellModel: Identifiable, Hashable {
        let id: String
        var user: UserModel
        var lastMessage: String
        var timeMessage: Date
    }
}

extension ChatListModel.ChatCellModel {
    init(from model: UserEntity) {
        self = .init(
            id: UUID().uuidString,
            user: UserModel(from: model),
            lastMessage: "У вас новое сообщение!",
            timeMessage: Date()
        )
    }
}
