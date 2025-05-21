//
//  CakeDetailsView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import SwiftUI
import SwiftData

struct CakeDetailsView: View {
    @State var viewModel: CakeDetailsDisplayData & CakeDetailsViewModelInput
    @Environment(Coordinator.self) private var coordinator
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator, modelContext: modelContext)
            viewModel.fetchCakeDetails()
        }
        .navigationDestination(for: CakeDetailsModel.Screens.self) { screen in
            openNextScreen(screen)
        }
    }
}

// MARK: - Navigation Destination

private extension CakeDetailsView {
    @ViewBuilder
    func openNextScreen(_ screen: CakeDetailsModel.Screens) -> some View {
        switch screen {
        case .ratingReviews:
            viewModel.assemblyRatingReviewsView()
        case let .arQuickView(remoteURL):
            ARQuickRemoteLook(remoteURL: remoteURL)
        }
    }
}
