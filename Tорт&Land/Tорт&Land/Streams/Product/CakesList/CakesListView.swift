//
//  CakesListView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

struct CakesListView: View {
    @State var viewModel: CakesListDisplayLogic & CakesListViewModelOutput

    var body: some View {
        mainContainer.onAppear {
            viewModel.fetchData()
        }
    }
}

// MARK: - Preview

#Preview {
    CakesListView(viewModel: CakesListViewModelMock(delay: 2))
}
