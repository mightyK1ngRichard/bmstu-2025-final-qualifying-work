//
//  ChatListProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import UIKit
import DesignSystem

protocol ChatListDisplayLogic {
    var uiProperties: ChatListModel.UIProperties { get set }
    var cells: [ChatListModel.ChatCellModel] { get }
}

protocol ChatListViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func fetchChatsHistory()
    func configureChatCell(with model: ChatListModel.ChatCellModel) -> TLChatCell.Configuration
    func configureChatView(with model: ChatListModel.ChatCellModel) -> ChatView
}

protocol ChatListViewModelOutput {
    func didTapCell(cell: ChatListModel.ChatCellModel)
}
