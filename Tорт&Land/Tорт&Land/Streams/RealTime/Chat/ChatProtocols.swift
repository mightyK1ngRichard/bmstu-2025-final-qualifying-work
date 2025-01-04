//
//  ChatProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol ChatDisplayLogic: ChatViewModelInput {
    var uiProperties: ChatModel.UIProperties { get set }
    var currentUser: UserModel { get }
    var messages: [ChatModel.ChatMessage] { get }
    var lastMessageID: String? { get }
}

protocol ChatViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
}

protocol ChatViewModelOutput {
    func didTapSendMessageButton()
}
