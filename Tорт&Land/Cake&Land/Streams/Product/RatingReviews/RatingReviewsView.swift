//
//  RatingReviewsView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct RatingReviewsView: View {
    @State var viewModel: RatingReviewsDisplayLogic & RatingReviewsViewModelInput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
            viewModel.fetchComments()
        }
    }
}
