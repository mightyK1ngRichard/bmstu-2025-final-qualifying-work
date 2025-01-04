//
//  ChatListView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension ChatListView {
    var mainContainer: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    cellsContainer
                } header: {
                    searchBarView
                }
            }
            .padding(.horizontal)
        }
        .background(Constants.bgColor)
    }
}

private extension ChatListView {
    @ViewBuilder
    var cellsContainer: some View {
        switch viewModel.uiProperties.screenState {
        case .initial, .loading:
            shimmeringView
        case .finished:
            ForEach(viewModel.cells) { cell in
                cellView(for: cell)
            }
        case .error:
            Text("Error")
        }
    }

    func cellView(for model: ChatListModel.ChatCellModel) -> some View {
        VStack {
            TLChatCell(
                configuration: viewModel.configureChatCell(with: model)
            )
            Divider()
        }
        .contentShape(.rect)
        .onTapGesture {
            viewModel.didTapCell(cell: model)
        }
    }

    var shimmeringView: some View {
        ForEach(1...10, id: \.self) { _ in
            VStack {
                TLChatCell(configuration: .shimmering)
                Divider()
            }
        }
    }

    var searchBarView: some View {
        HStack(spacing: 12) {
            Image(.magnifier)
                .renderingMode(.template)
                .foregroundStyle(TLColor<IconPalette>.iconSecondary.color)

            TextField(Constants.searchTitle, text: $viewModel.uiProperties.searchText)
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 15)
        .background(TLColor<BackgroundPalette>.bgSearchBar.color, in: .capsule)
        .padding(.bottom)
    }
}

// MARK: - Preview

#Preview {
    ChatListView(
        viewModel: ChatListViewModelMock(delay: 5)
    )
    .environment(Coordinator())
}

private extension ChatListView {
    enum Constants {
        static let bgColor: Color = TLColor<BackgroundPalette>.bgMainColor.color
        static let emptyImageColor = TLColor<IconPalette>.iconPrimary.color
        static let searchTitle = String(localized: "Search")
        static let emptyText = String(localized: "The chat history is empty")
    }
}
