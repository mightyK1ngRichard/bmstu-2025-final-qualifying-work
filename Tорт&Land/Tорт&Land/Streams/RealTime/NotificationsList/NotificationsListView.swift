//
//  NotificationsListView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct NotificationsListView: View {
    @State var viewModel: NotificationsListDisplayLogic & NotificationsListViewModelOutput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
            viewModel.subscribe()
            viewModel.fetchNotifications()
        }
        .navigationDestination(for: NotificationsListModel.Screens.self) { screen in
            openNextScreen(for: screen)
        }
    }
}

// MARK: - Navigation Destination

private extension NotificationsListView {
    @ViewBuilder
    func openNextScreen(for screen: NotificationsListModel.Screens) -> some View {
        switch screen {
        case let .details(notification):
            viewModel.assemblyNotificationDetails(with: notification)
        }
    }
}

// MARK: - Preview

#Preview {
    NotificationsListView(
        viewModel: NotificationsListViewModelMock(delay: 1)
    )
    .environment(Coordinator())
}
