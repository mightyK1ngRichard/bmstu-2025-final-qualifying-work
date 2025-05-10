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
                case let .error(content):
                    TLErrorView(
                        configuration: .init(from: content),
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

    var shimmeringView: some View {
        ForEach(1...10, id: \.self) { _ in
            TLNotificationCell(configuration: .init(isShimmering: true))
        }
    }
}

// MARK: - Preview

#if DEBUG
import NetworkAPI
#endif

#Preview {
    let network = NetworkServiceImpl()
    network.setRefreshToken(CommonMockData.refreshToken)
    let authService = AuthGrpcServiceImpl(
        configuration: AppHosts.auth,
        networkService: network
    )

    return NotificationsListAssembler.assemble(
        notificationService: NotificationServiceImpl(
            configuration: AppHosts.notification,
            authService: authService,
            networkService: network
        ),
        cakeService: CakeGrpcServiceImpl(
            configuration: AppHosts.cake,
            authService: authService,
            networkService: network
        ),
        orderService: OrderGrpcServiceImpl(
            configuration: AppHosts.order,
            authService: authService,
            networkService: network
        ),
        imageProvider: ImageLoaderProviderImpl()
    )
    .environment(Coordinator())
}
