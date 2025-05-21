//
//  ChatListView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct ChatListView: View {
    @State var viewModel: ChatListDisplayLogic & ChatListViewModelOutput & ChatListViewModelInput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
            viewModel.fetchChatsHistory()
        }
        .navigationDestination(for: ChatListModel.Screens.self) { screen in
            openNextScreen(for: screen)
        }
    }
}

// MARK: - Navigation Destination

private extension ChatListView {
    @ViewBuilder
    func openNextScreen(for screen: ChatListModel.Screens) -> some View {
        switch screen {
        case let .chat(chatModel):
            viewModel.configureChatView(with: chatModel)
        }
    }
}
