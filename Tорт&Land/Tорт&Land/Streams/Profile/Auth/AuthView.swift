//
//  AuthView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//

import SwiftUI

struct AuthView: View {
    @State var viewModel: AuthDisplayLogic & AuthViewModelOutput
    @Environment(StartScreenControl.self) private var startScreenControl

    var body: some View {
        ZStack {
            mainView
        }
        .background(TLColor<BackgroundPalette>.bgMainColor.color.gradient)
        .ignoresSafeArea()
        .onAppear {
            viewModel.setStartScreenControl(startScreenControl)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AuthView(viewModel: AuthViewModelMock())
    }
}
