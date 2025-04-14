//
//  ProductsGridView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct ProductsGridView: View {
    @State var viewModel: ProductsGridDisplayData & ProductsGridViewModelInput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
        }
    }
}

// MARK: - Preview

#Preview {
    ProductsGridView(
        viewModel: ProductsGridViewModelMock()
    )
    .environment(Coordinator())
}
