//
//  NotificationsListView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem

extension NotificationsListView {
    var mainContainer: some View {
        ScrollView {
            LazyVStack {
                switch viewModel.uiProperties.screenState {
                case .initial, .loading:
                    shimmeringView
                case .finished:
                    notificationsList
                case let .error(errorMessage):
                    TLErrorView(
                        configuration: .init(kind: .customError("Network error", errorMessage)),
                        action: viewModel.didTapReloadButton
                    )
                }
            }
            .padding(.horizontal)
        }
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
    }
}

// MARK: - UI Subviews

private extension NotificationsListView {
    var notificationsList: some View {
        ForEach(viewModel.notifications) { notification in
            TLNotificationCell(
                configuration: viewModel.configureNotificationCell(for: notification),
                deleteHandler: viewModel.didDeleteNotification(id:)
            )
            .contentShape(.rect)
            .onTapGesture {
                viewModel.didTapNotificationCell(with: notification)
            }
        }
    }

    var shimmeringView: some View {
        ForEach(1...10, id: \.self) { _ in
            TLNotificationCell(configuration: .init(isShimmering: true))
        }
    }
}

// MARK: - Preview

#Preview("Mockable delay") {
    NotificationsListView(
        viewModel: NotificationsListViewModelMock(delay: 3)
    )
    .environment(Coordinator())
}
