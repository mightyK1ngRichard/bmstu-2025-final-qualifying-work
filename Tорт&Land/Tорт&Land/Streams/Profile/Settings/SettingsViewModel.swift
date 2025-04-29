//
//  SettingsViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import SwiftUI
import MapKit

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

    func assemblyMapView() -> some View {
        let viewModel = UserLocationViewModel { [weak self] placemark in
            guard let self else { return }
            try await addUserAddress(placemark: placemark)
        }

        return UserLocationView(viewModel: viewModel)
    }

}

// MARK: - Models

extension SettingsViewModel {
    struct UIProperties: Hashable {
        var state: ScreenState = .initial
    }

    enum Screens: Hashable {
        case addAddress
    }
}

// MARK: - Setter

extension SettingsViewModel {
    func setCoordinator(_ coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
