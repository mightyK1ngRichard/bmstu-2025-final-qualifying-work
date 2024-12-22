//
//  CakeDetailsView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import SwiftUI

struct CakeDetailsView: View {
    @State var viewModel: CakeDetailsDisplayLogic & CakeDetailsViewModelOutput

    var body: some View {
        mainContainer
    }
}

// MARK: - Preview

#Preview {
    CakeDetailsView(viewModel: CakeDetailsViewModelMock())
}
