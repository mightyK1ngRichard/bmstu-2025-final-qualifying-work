//
//  RootView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem

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
                TLErrorView(
                    configuration: viewModel.assemblyChatListErrorView(),
                    action: viewModel.reloadGetUserInfo
                )
                .padding(.horizontal, 50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(TLColor<BackgroundPalette>.bgMainColor.color)
            }
        case .notifications:
            viewModel.assemblyNotificationsListView()
        case .profile:
            viewModel.assemblyProfileView()
        }
    }
}
