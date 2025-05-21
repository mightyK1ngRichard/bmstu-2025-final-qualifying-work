//
//  CategoriesView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @State var viewModel: CategoriesDisplayLogic & CategoriesViewModelInput
    @Environment(Coordinator.self) private var coordinator
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator, modelContext: modelContext)
            viewModel.onAppear()
        }
        .navigationDestination(for: CategoriesModel.Screens.self) { screen in
            openNextScreen(for: screen)
        }
    }
}

// MARK: - Navigation Destination

private extension CategoriesView {
    @ViewBuilder
    func openNextScreen(for screen: CategoriesModel.Screens) -> some View {
        switch screen {
        case let .cakes(cakes):
            viewModel.assemlyCakesCategoryView(cakes: cakes)
        }
    }
}
