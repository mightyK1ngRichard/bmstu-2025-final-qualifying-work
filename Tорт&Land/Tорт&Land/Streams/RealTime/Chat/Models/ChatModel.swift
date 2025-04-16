//
//  ChatModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum ChatModel {}

extension ChatModel {
    struct UIProperties: Hashable {
        var messageText = ""
        var isLoading = false
    }

    struct ChatMessage: Identifiable, Hashable {
        var id: String
        let isYou: Bool
        let message: String
        let user: UserModel
        let time: String
        let state: MessageState
    }
}

extension ChatModel.ChatMessage {
    enum MessageState: String, Hashable {
        case progress
        case received
        case error
    }
}
