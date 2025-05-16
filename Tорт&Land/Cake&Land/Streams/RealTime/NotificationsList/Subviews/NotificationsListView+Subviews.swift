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
        content
            .background(TLColor<BackgroundPalette>.bgMainColor.color)
    }
}

// MARK: - UI Subviews

private extension NotificationsListView {
    @ViewBuilder
    var content: some View {
        switch viewModel.uiProperties.screenState {
        case .initial, .loading:
            shimmeringView
        case .finished:
            notificationsContainer
        case let .error(content):
            TLErrorView(
                configuration: .init(from: content),
                action: viewModel.didTapReloadButton
            )
            .padding()
            .frame(maxHeight: .infinity)
        }
    }

    @ViewBuilder
    var notificationsContainer: some View {
        if viewModel.notifications.isEmpty {
            emptyNotificationsView
        } else {
            notificationsList
        }
    }

    var notificationsList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.notifications, id: \.id) { notification in
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
            .padding(.horizontal)
        }
    }

    var emptyNotificationsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(.gray.opacity(0.6))

            Text("Уведомлений нет")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text("Здесь появятся уведомления о заказах, сообщениях и других событиях.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    var shimmeringView: some View {
        ScrollView {
            VStack {
                ForEach(1...10, id: \.self) { _ in
                    TLNotificationCell(configuration: .init(isShimmering: true))
                }
            }
            .padding(.horizontal)
        }
    }
}
