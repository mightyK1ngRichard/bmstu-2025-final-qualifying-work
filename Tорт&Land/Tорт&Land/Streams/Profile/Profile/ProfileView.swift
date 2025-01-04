//
//  ProfileView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 03.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileDisplayLogic & ProfileViewModelOutput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView(
        viewModel: ProfileViewModelMock()
    )
    .environment(Coordinator())
}
