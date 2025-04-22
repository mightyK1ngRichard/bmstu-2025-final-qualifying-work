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
        switch viewModel.screenKind {
        case .initial, .auth:
            viewModel.assemblyAuthView()
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
        switch viewModel.activeTab {
        case .house:
            viewModel.assemblyCakeListView()
        case .categories:
            viewModel.assemblyCategoriesView()
        case .chat:
            if let currentUser = viewModel.currentUser {
                viewModel.assemblyChatListView(userModel: currentUser)
            } else {
                Text("Current User not found")
                    .frame(maxHeight: .infinity)
                TLErrorView(
                    configuration: viewModel.assemblyChatListErrorView(),
                    action: viewModel.reloadGetUserInfo
                )
            }
        case .notifications:
            viewModel.assemblyNotificationsListView()
        case .profile:
            viewModel.assemblyProfileView()
        }
    }
}

// MARK: - Preview

#Preview {
    RootView(
        viewModel: RootViewModelMock()
    )
    .environment(Coordinator())
}
