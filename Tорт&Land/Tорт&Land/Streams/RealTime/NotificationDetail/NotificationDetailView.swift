//
//  NotificationDetailView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct NotificationDetailView: View {
    @State var viewModel: NotificationDetailDisplayLogic & NotificationDetailViewModelOutput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
        }
    }
}

// MARK: - Preview

#Preview {
    NotificationDetailView(
        viewModel: NotificationDetailViewModelMock()
    )
    .environment(Coordinator())
}
