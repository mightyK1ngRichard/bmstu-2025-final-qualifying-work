//
//  ChatListViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG

import Foundation
import Observation

@Observable
final class ChatListViewModelMock: ChatListDisplayLogic, ChatListViewModelInput, ChatListViewModelOutput {
    var uiProperties = ChatListModel.UIProperties()
    var cells: [ChatListModel.ChatCellModel] {
        uiProperties.searchText.isEmpty
            ? allChatCells
            : allChatCells.filter { $0.user.name.contains(uiProperties.searchText) }
    }
    @ObservationIgnored
    var delay: TimeInterval
    private var allChatCells: [ChatListModel.ChatCellModel]
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        delay: TimeInterval = 0,
        cells: [ChatListModel.ChatCellModel] = []
    ) {
        self.delay = delay
        self.allChatCells = cells
    }

    func fetchChatsHistory() {
        uiProperties.screenState = .loading
        Task {
            try? await Task.sleep(for: .seconds(delay))
            await MainActor.run {
                allChatCells = MockData.mockCells
                uiProperties.screenState = .finished
            }
        }
    }

    func didTapCell(cell: ChatListModel.ChatCellModel) {
        print("[DEBUG]: chat cell id=\(cell.id)")
        coordinator?.addScreen(ChatListModel.Screens.chat(cell))
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Configurations

extension ChatListViewModelMock {
    func configureChatView(with model: ChatListModel.ChatCellModel) -> ChatView {
        let viewModel = ChatViewModelMock()
        return ChatView(viewModel: viewModel)
    }

    func configureChatCell(with model: ChatListModel.ChatCellModel) -> TLChatCell.Configuration {
        .basic(
            imageState: model.user.avatarImage,
            title: model.user.name,
            subtitle: model.lastMessage,
            time: model.timeMessage.formattedHHmm
        )
    }
}

// MARK: - MockData

private extension ChatListViewModelMock {
    enum MockData {
        static let mockCells: [ChatListModel.ChatCellModel] = (1...20).map {
            .init(
                id: String($0),
                user: CommonMockData.generateMockUserModel(id: $0),
                lastMessage: "Последнее сообщение чата #\($0)",
                timeMessage: Date.now
            )
        }
    }
}

#endif
