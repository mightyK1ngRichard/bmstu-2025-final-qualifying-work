//
//  RootView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @State var viewModel: RootDisplayData & RootViewModelInput
    @State private var coordinator = Coordinator()

    var body: some View {
        NavigationStack(path: $coordinator.navPath) {
            mainContainer.onFirstAppear {
                viewModel.setEnvironmentObjects(coordinator)
                viewModel.fetchUserInfoIfNeeded()
            }
            .defaultAlert(
                errorContent: viewModel.uiProperties.alert.errorContent,
                isPresented: $viewModel.uiProperties.alert.isShown,
                action: viewModel.didTapAlertButton
            )
            .navigationDestination(for: RootModel.Screens.self) { screen in
                openNextScreen(for: screen)
            }
        }
        .tint(.primary)
        .environment(coordinator)
    }
}

// MARK: - Navigation Destination

private extension RootView {
    @ViewBuilder
    func openNextScreen(for screen: RootModel.Screens) -> some View {
        switch screen {
        case let .details(cakeModel):
            viewModel.assemblyDetailsView(model: cakeModel)
        case let .profile(userModel):
            viewModel.assemblyProfileView(userModel: userModel)
        case let .makeOrder(cakeID):
            viewModel.assemblyOrderView(cakeID: cakeID)
        }
    }
}

// MARK: - Preview

#Preview {
    RootAssembler.assembleMock()
        .environment(Coordinator())
}
