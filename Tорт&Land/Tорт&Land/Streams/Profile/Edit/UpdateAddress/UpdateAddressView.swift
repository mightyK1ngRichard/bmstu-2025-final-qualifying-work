//
//  UpdateAddressView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem

struct UpdateAddressView: View {
    @State var viewModel: UpdateAddressViewModel
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        ScrollView {
            if viewModel.uiProperties.errorMessage == nil {
                inputCodes
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .onFirstAppear {
            viewModel.setCoordinator(coordinator: coordinator)
            viewModel.onAppear()
        }
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .overlay(alignment: .bottom) {
            if viewModel.uiProperties.errorMessage == nil {
                TLButton(
                    configuration: viewModel.saveButtonConfiguration(),
                    action: viewModel.didTapSaveButton
                )
                .padding(.horizontal)
            }
        }
        .overlay {
            loadingView
            errorView
        }
    }
}

// MARK: - UI Subviews

private extension UpdateAddressView {

    var inputCodes: some View {
        VStack(alignment: .leading, spacing: 20) {
            TLInputCode(
                configuration: .init(
                    title: "Подъезд",
                    placeholder: Constants.entrancePlaceholder
                ),
                inputText: $viewModel.uiProperties.inputEntrance
            )

            TLInputCode(
                configuration: .init(
                    title: "Этаж",
                    placeholder: Constants.entranceFloorPlaceholder
                ),
                inputText: $viewModel.uiProperties.inputFloor
            )

            TLInputCode(
                configuration: .init(
                    title: "Квартира",
                    placeholder: Constants.apartmentPlaceholder
                ),
                inputText: $viewModel.uiProperties.inputApartment
            )

            TLInputCode(
                configuration: .init(
                    title: "Комментарий к доставке",
                    placeholder: Constants.commentPlaceholder
                ),
                inputText: $viewModel.uiProperties.inputComment
            )
        }
    }

    @ViewBuilder
    var loadingView: some View {
        if viewModel.uiProperties.isLoading {
            ZStack {
                Color.black.opacity(0.6)
                ProgressView()
            }
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    var errorView: some View {
        if let errorMessage = viewModel.uiProperties.errorMessage {
            TLErrorView(
                configuration: .init(
                    kind: .customError("Network Error", errorMessage)
                ),
                action: viewModel.onAppear
            )
            .padding(.horizontal)
        }
    }

}

private extension UpdateAddressView {

    enum Constants {
        static let entrancePlaceholder = "Номер подъезда"
        static let entranceFloorPlaceholder = "Номер этажа"
        static let apartmentPlaceholder = "Номер этажа"
        static let commentPlaceholder = "Остановитесь возле шлагбаума"
    }
}
