//
//  CakesListView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

struct CakesListView: View {
    @State var viewModel: CakesListDisplayLogic & CakesListViewModelOutput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
            viewModel.fetchData()
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
        case let .tags(cakes, sectionKind):
            viewModel.assemblyTagsView(cakes: cakes, sectionKind: sectionKind)
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable
    @State var coordinator = Coordinator()
    NavigationStack(path: $coordinator.navPath) {
        CakesListView(viewModel: CakesListViewModelMock(delay: 2))
    }
    .environment(coordinator)
}
