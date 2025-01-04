//
//  CakesLandApp.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

@main
struct CakesLandApp: App {
    @State private var startScreenControl = StartScreenControl()
    @State private var coordinator = Coordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navPath) {
                contentView
            }
            .environment(startScreenControl)
            .environment(coordinator)
        }
    }
}

private extension CakesLandApp {
    @ViewBuilder
    var contentView: some View {
        switch startScreenControl.screenKind {
        case .initial, .auth:
            let viewModel = AuthViewModelMock()
            AuthView(viewModel: viewModel)
        case .cakesList:
            tabBarView
        }
    }

    var tabBarView: some View {
        VStack(spacing: 0) {
            allTabBarViews
            TLCustomTabBarView()
        }
    }
}

// MARK: - Tab Views

private extension CakesLandApp {
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
        let viewModel = CakesListViewModelMock(delay: 2)
        CakesListView(viewModel: viewModel)
    }

    @ViewBuilder
    var categoriesScreen: some View {
        let viewModel = CategoriesViewModelMock()
        CategoriesView(viewModel: viewModel)
    }

    @ViewBuilder
    var chatScreen: some View {
        Text("Chat")
            .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    var notificationsScreen: some View {
        Text("Notifications")
            .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    var profileScreen: some View {
        Text("Profile")
            .frame(maxHeight: .infinity)
    }
}
