//
//  ProfileView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 03.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
#if DEBUG
import NetworkAPI
#endif

struct ProfileView: View {
    @State var viewModel: ProfileDisplayLogic & ProfileViewModelInput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
            viewModel.fetchUserData()
        }
        .navigationDestination(for: ProfileModel.Screens.self) { screen in
            openNextScreen(for: screen)
        }
    }
}

// MARK: - Navigation Destionation

private extension ProfileView {
    @ViewBuilder
    func openNextScreen(for screen: ProfileModel.Screens) -> some View {
        switch screen {
        case .createProfile:
            viewModel.assemblyCreateCakeView()
        case let .sendMessage(interlocutor):
            viewModel.assemblyChatView(interlocutor: interlocutor)
        case let .settings(userModel):
            viewModel.assemblySettingsView(userModel: userModel)
        case .orders:
            viewModel.assemblyOrdersView()
        }
    }
}

// MARK: - Preview

#Preview("Mockable") {
    ProfileView(
        viewModel: ProfileViewModelMock(isCurrentUser: true)
    )
    .environment(Coordinator())
}
