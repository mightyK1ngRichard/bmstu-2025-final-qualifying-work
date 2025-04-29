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

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        List {
            content
                .listRowBackground(Constants.rowColor)
        }
        .background(Constants.bgColor)
        .scrollContentBackground(.hidden)
        .onFirstAppear {
            viewModel.setCoordinator(coordinator)
            viewModel.fetchAddresses()
        }
        .navigationTitle("Settings")
        .navigationDestination(for: SettingsViewModel.Screens.self) { screen in
            switch screen {
            case .addAddress:
                viewModel.assemblyMapView()
            }
        }
    }
}

private extension SettingsView {

    @ViewBuilder
    var content: some View {
        switch viewModel.uiProperties.state {
        case .initial, .loading:
            ProgressView()
        case .finished:
            addressesView
        case let .error(message):
            errorView(message: message)
        }
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

    func errorView(message: String) -> some View {
        TLErrorView(
            configuration: .init(
                kind: .customError("Network error", message)
            )
        )
    }

}

// MARK: - Preview

#Preview {
    var network = NetworkServiceImpl()
    network.setRefreshToken(CommonMockData.refreshToken)

    return NavigationStack {
        SettingsView(
            viewModel: SettingsViewModel(
                profileProvider: ProfileGrpcServiceImpl(
                    configuration: AppHosts.profile,
                    authService: AuthGrpcServiceImpl(
                        configuration: AppHosts.auth,
                        networkService: network
                    ),
                    networkService: network
                )
            )
        )
    }
    .environment(Coordinator())
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
