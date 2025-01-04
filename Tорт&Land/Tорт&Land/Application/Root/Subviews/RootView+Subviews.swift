//
//  RootView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension RootView {
    @ViewBuilder
    var mainContainer: some View {
        switch startScreenControl.screenKind {
        case .initial, .auth:
            let viewModel = AuthViewModelMock()
            AuthView(viewModel: viewModel)
        case .cakesList:
            tabBarView
        }
    }

    private var tabBarView: some View {
        VStack(spacing: 0) {
            allTabBarViews
            TLCustomTabBarView()
        }
    }
}

// MARK: - Tab Views

private extension RootView {
    @ViewBuilder
    var allTabBarViews: some View {
        switch coordinator.activeTab {
        case .house:
            cakeListScreen
        case .categories:
            categoriesScreen
        case .chat:
            chatScreen
        case .notifications:
            notificationsScreen
        case .profile:
            profileScreen
        }
    }

    @ViewBuilder
    var cakeListScreen: some View {
        let viewModel = CakesListViewModelMock(delay: 3)
        CakesListView(viewModel: viewModel)
    }

    @ViewBuilder
    var categoriesScreen: some View {
        let viewModel = CategoriesViewModelMock()
        CategoriesView(viewModel: viewModel)
    }

    @ViewBuilder
    var chatScreen: some View {
        let viewModel = ChatListViewModelMock(delay: 3)
        ChatListView(viewModel: viewModel)
    }

    @ViewBuilder
    var notificationsScreen: some View {
        let viewModel = NotificationsListViewModelMock(delay: 3)
        NotificationsListView(viewModel: viewModel)
    }

    @ViewBuilder
    var profileScreen: some View {
        let viewModel = ProfileViewModelMock(isCurrentUser: true)
        ProfileView(viewModel: viewModel)
    }
}

// MARK: - Preview

#Preview {
    RootView(
        viewModel: RootViewModelMock()
    )
    .environment(Coordinator())
}
