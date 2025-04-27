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

extension SettingsViewModel {
    struct UIProperties: Hashable {
        var state: ScreenState = .initial
    }

    enum Screens: Hashable {
        case addAddress
    }
}

@Observable
final class SettingsViewModel {
    var uiProperties = UIProperties()
    private(set) var addresses: [AddressEntity] = []
    @ObservationIgnored
    private let profileProvider: ProfileGrpcService
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(profileProvider: ProfileGrpcService) {
        self.profileProvider = profileProvider
    }
}

extension SettingsViewModel {

    func fetchAddresses() {
        uiProperties.state = .loading
        Task { @MainActor in
            do {
                addresses = try await profileProvider.getUserAddresses()
                uiProperties.state = .finished
            } catch {
                uiProperties.state = .error(message: "\(error)")
            }
        }
    }

    @MainActor
    func addUserAddress(placemark: MKPlacemark) async throws {
        let createdAddress = try await profileProvider.createAddress(
            req: .init(
                latitude: placemark.coordinate.latitude,
                longitude: placemark.coordinate.longitude,
                formattedAddress: placemark.title ?? "\(placemark.coordinate)"
            )
        )

        addresses.append(createdAddress)
    }

    func assemblyUpdateAddressView(address: AddressEntity) -> some View {
        let viewModel = UpdateAddressViewModel(
            address: address,
            profileProvider: profileProvider
        ) { [weak self] updatedAddress in
            guard
                let self,
                let index = addresses.firstIndex(where: { $0.id == updatedAddress.id })
            else { return }

            addresses[index] = updatedAddress
        }

        return UpdateAddressView(viewModel: viewModel)
    }

    func didTapAddAddress() {
        coordinator?.addScreen(SettingsViewModel.Screens.addAddress)
    }

    func setCoordinator(_ coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func assemblyMapView() -> some View {
        let viewModel = UserLocationViewModel { [weak self] placemark in
            guard let self else { return }
            try await addUserAddress(placemark: placemark)
        }

        return UserLocationView(viewModel: viewModel)
    }

}

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
    network.setRefreshToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDYxNTE3NDYsInVzZXJJRCI6IjIyODIyNzNmLTk4NmYtNDc0MS04OTM2LWRmMzEyNDhlMzljYiJ9.t1aSbfDSZLdxYK_Y0WlzaOcwl1hDTbk4WyVcFC973OE")

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
