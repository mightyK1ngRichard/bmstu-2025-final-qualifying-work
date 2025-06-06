//
//  ChatView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    @State var viewModel: ChatDisplayLogic & ChatViewModelInput
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
            viewModel.fetchMessages()
        }
        .defaultAlert(
            errorContent: viewModel.uiProperties.alert.content,
            isPresented: $viewModel.uiProperties.alert.isShown
        )
    }
}
