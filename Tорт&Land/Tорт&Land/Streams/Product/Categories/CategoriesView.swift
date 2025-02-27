//
//  CategoriesView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    @State var viewModel: CategoriesDisplayLogic & CategoriesViewModelOutput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
        }
    }
}

// MARK: - Preview

#Preview {
    CategoriesView(
        viewModel: CategoriesViewModelMock()
    )
    .environment(Coordinator())
}
