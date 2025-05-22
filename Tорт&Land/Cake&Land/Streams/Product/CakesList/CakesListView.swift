//
//  CakesListView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI
import SwiftData

struct CakesListView: View {
    @State var viewModel: CakesListDisplayData & CakesListViewModelInput
    @Environment(Coordinator.self) private var coordinator
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator, modelContext: modelContext)
            viewModel.fetchData(fromMemory: false)
        }
        .onOpenURL { url in
            guard let scheme = url.scheme, scheme == "cakeland",
                  url.host() == "cake"
            else { return }

            let cakeID = url.lastPathComponent
            viewModel.openCakeFromDeepLink(cakeID: cakeID)
        }
        .navigationDestination(for: CakesListModel.Screens.self) { screen in
            openNextScreen(screen)
        }
    }
}

// MARK: - Navigation Destination

private extension CakesListView {
    @ViewBuilder
    func openNextScreen(_ screen: CakesListModel.Screens) -> some View {
        switch screen {
        case let .grid(cakes):
            viewModel.assemblyTagsView(cakes: cakes)
        }
    }
}
