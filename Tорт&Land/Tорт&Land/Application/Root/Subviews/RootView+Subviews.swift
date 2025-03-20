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
        switch viewModel.activeTab {
        case .house:
            viewModel.assemblyCakeListView()
        case .categories:
            viewModel.assemblyCategoriesView()
        case .chat:
            viewModel.assemblyChatListView()
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
