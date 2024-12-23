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
            let viewModel = CakesListViewModelMock(delay: 2)
            CakesListView(viewModel: viewModel)
        }
    }
}
