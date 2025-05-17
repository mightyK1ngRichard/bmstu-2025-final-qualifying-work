//
//  SettingsView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI
import MapKit
import PhotosUI
import DesignSystem
import Core

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    @FocusState private var isFocused: Bool
    @Environment(Coordinator.self) private var coordinator
    @Environment(StartScreenControl.self) private var startScreenControl

    var body: some View {
        Form {
            content
                .listRowBackground(Constants.rowColor)
        }
        .background(Constants.bgColor)
        .scrollContentBackground(.hidden)
        .onFirstAppear {
            viewModel.setCoordinator(coordinator, startScreenControl)
            viewModel.fetchAddresses()
        }
        .navigationTitle("Settings")
        .photosPicker(
            isPresented: $viewModel.uiProperties.showPhotoPicker,
            selection: $viewModel.uiProperties.selectedImage,
            preferredItemEncoding: .automatic
        )
        .defaultAlert(
            errorContent: viewModel.uiProperties.alert.errorContent,
            isPresented: $viewModel.uiProperties.alert.isShown
        )
        .onChange(of: viewModel.uiProperties.selectedImage) { _, newValue in
            viewModel.didUpdateImage(with: newValue)
        }
        .navigationDestination(for: SettingsViewModel.Screens.self) { screen in
            switch screen {
            case .addAddress:
                viewModel.assemblyMapView()
            }
        }
    }
}

// MARK: - UI Subviews

private extension SettingsView {

    @ViewBuilder
    var content: some View {
        switch viewModel.uiProperties.state {
        case .initial, .loading:
            ProgressView()
        case .finished:
            avatarView
            updateHeaderImageButton
            editUserInfoContainer
            addressesView
            logoutButton
        case let .error(content):
            errorView(content: content)
        }
    }

    var avatarView: some View {
        VStack {
            TLImageView(
                configuration: .init(imageState: viewModel.userModel.avatarImage)
            )
            .frame(width: 100, height: 100)
            .frame(maxWidth: .infinity, alignment: .center)
            .clipShape(.circle)
            .overlay {
                Circle()
                    .stroke(lineWidth: 1)
                    .padding(1)
            }

            Button {
                viewModel.uiProperties.selectedImageKind = .avatar
                viewModel.didTapUpdateAvatar()
            } label: {
                Text("Update image")
                    .style(16, .regular)
            }
        }
        .padding()
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
        .background {
            TLImageView(configuration: .init(imageState: viewModel.userModel.headerImage))
            TLColor<BackgroundPalette>.bgPrimary.color.opacity(0.3)
        }
    }

    var editUserInfoContainer: some View {
        Section(header: Text("Edit user info")) {
            HStack {
                pencilImage
                TextField("Input new nickname", text: $viewModel.uiProperties.inputNickname)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($isFocused)
            }

            HStack {
                pencilImage
                TextField("Input new full name", text: $viewModel.uiProperties.inputFIO)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .focused($isFocused)
            }

            Button("Update") {
                isFocused = false
                viewModel.didTapUpdateUserData()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(.bordered)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
            .disabled(viewModel.updateButtonIsDisable)
        }
    }

    var updateHeaderImageButton: some View {
        Section(header: Text("Update header image")) {
            Button {
                viewModel.uiProperties.selectedImageKind = .header
                viewModel.didTapUpdateAvatar()
            } label: {
                Label("Select header image", systemImage: "photo")
            }
        }
    }

    var pencilImage: some View {
        Image(uiImage: TLAssets.pen)
            .renderingMode(.template)
            .foregroundStyle(viewModel.uiProperties.penState.color)
    }

    var addressesView: some View {
        Section(header: Text("Your addresses")) {
            ForEach(viewModel.addresses, id: \.id) { address in
                NavigationLink {
                    viewModel.assemblyUpdateAddressView(address: address)
                } label: {
                    Text(address.formattedAddress.capitalized)
                        .style(16, .regular)
                }
            }

            Button {
                viewModel.didTapAddAddress()
            } label: {
                Label("Add address", systemImage: "plus")
            }
            .foregroundStyle(Constants.textSecondary)
        }
    }

    var logoutButton: some View {
        Button(action: {
            viewModel.didTapLogout()
        }) {
            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                .foregroundStyle(TLColor<TextPalette>.textWild.color)
        }
    }

    func errorView(content: ErrorContent) -> some View {
        TLErrorView(
            configuration: .init(from: content),
            action: viewModel.fetchAddresses
        )
    }

}

// MARK: - Constants

private extension SettingsView {

    enum Constants {
        static let textColor = TLColor<TextPalette>.textPrimary.color
        static let textSecondary = TLColor<TextPalette>.textSecondary.color
        static let deleteColor = TLColor<TextPalette>.textWild.color
        static let userMailColor = TLColor<TextPalette>.textPrimary.color
        static let bgColor = TLColor<BackgroundPalette>.bgMainColor.color
        static let rowColor = TLColor<BackgroundPalette>.bgCommentView.color
    }
}
