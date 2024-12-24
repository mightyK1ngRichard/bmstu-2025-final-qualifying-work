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
        mainContainer
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
