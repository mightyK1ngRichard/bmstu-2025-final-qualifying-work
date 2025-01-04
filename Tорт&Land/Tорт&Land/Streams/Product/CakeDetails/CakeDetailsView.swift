//
//  CakeDetailsView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import SwiftUI

struct CakeDetailsView: View {
    @State var viewModel: CakeDetailsDisplayLogic & CakeDetailsViewModelOutput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
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
            viewModel.configureRatingReviewsView()
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable
    @State var coordinator = Coordinator()
    NavigationStack(path: $coordinator.navPath) {
        CakeDetailsView(viewModel: CakeDetailsViewModelMock())
    }
    .environment(coordinator)
}
