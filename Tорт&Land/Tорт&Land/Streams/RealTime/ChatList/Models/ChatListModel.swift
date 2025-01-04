//
//  ChatListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

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
