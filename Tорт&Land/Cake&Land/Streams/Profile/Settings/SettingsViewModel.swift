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
import DesignSystem
import MapKit
import Combine
import Core
import GRPC
import _PhotosUI_SwiftUI

@Observable
final class SettingsViewModel {
    var userPublisher = PassthroughSubject<UserModel, Never>()
    var uiProperties = UIProperties()

    private(set) var addresses: [AddressEntity] = []
    private(set) var userModel: UserModel
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private var startScreenControl: StartScreenControl?
    @ObservationIgnored
    private let rootViewModel: RootViewModel

    init(
        userModel: UserModel,
        networkManager: NetworkManager,
        rootViewModel: RootViewModel
    ) {
        self.userModel = userModel
        self.networkManager = networkManager
        self.rootViewModel = rootViewModel
    }

    var updateButtonIsDisable: Bool {
        (userModel.nickname == uiProperties.inputNickname && userModel.fio == uiProperties.inputFIO)
            || uiProperties.inputNickname.isEmpty
    }
}

extension SettingsViewModel {

    func fetchAddresses() {
        uiProperties.state = .loading
        Task { @MainActor in
            do {
                addresses = try await networkManager.profileService.getUserAddresses()
                uiProperties.state = .finished
            } catch {
                uiProperties.state = .error(content: error.readableGRPCContent)
            }
        }
    }

    @MainActor
    func addUserAddress(placemark: MKPlacemark) async throws {
        let createdAddress = try await networkManager.profileService.createAddress(
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
            profileProvider: networkManager.profileService
        ) { [weak self] updatedAddress in
            guard let self,
                  let index = addresses.firstIndex(where: { $0.id == updatedAddress.id })
            else { return }

            addresses[index] = updatedAddress
        }

        return UpdateAddressView(viewModel: viewModel)
    }

    func didTapAddAddress() {
        coordinator?.addScreen(SettingsViewModel.Screens.addAddress)
    }

    func didTapUpdateAvatar() {
        uiProperties.showPhotoPicker = true
    }

    func didTapLogout() {
        Task { @MainActor in
            do {
                try await networkManager.authService.logout()
                networkManager.closeConnections()
                rootViewModel.updateNetworkManager()
                startScreenControl?.update(with: .auth)
                coordinator?.goToRoot()
                coordinator?.activeTab = .house
                rootViewModel.updateCurrentUser(nil)
            } catch {
                uiProperties.alert = AlertModel(
                    errorContent: error.readableGRPCContent,
                    isShown: true
                )
            }
        }
    }

    func didTapUpdateUserData() {
        Task { @MainActor in
            do {
                uiProperties.penState = .loading
                let fio = uiProperties.inputFIO.isEmpty ? nil : uiProperties.inputFIO
                try await networkManager.profileService.updateUserData(username: uiProperties.inputNickname, userFIO: fio)
                userModel.fio = fio
                userModel.nickname = uiProperties.inputNickname
                uiProperties.penState = .updated
                userPublisher.send(userModel)
            } catch {
                uiProperties.alert = AlertModel(
                    errorContent: error.readableGRPCContent,
                    isShown: true
                )
                uiProperties.penState = .failed
            }

            try await Task.sleep(for: .seconds(1.5))
            uiProperties.penState = .initial
        }
    }

    func didUpdateImage(with item: PhotosPickerItem?) {
        Task { @MainActor in
            guard let imageData = try await item?.loadTransferable(type: Data.self) else {
                return
            }

            if let uiImage = UIImage(data: imageData) {
                let imageState: ImageState = .fetched(.uiImage(uiImage))
                switch uiProperties.selectedImageKind {
                case .avatar:
                    userModel.avatarImage = imageState
                case .header:
                    userModel.headerImage = imageState
                }

                userPublisher.send(userModel)
            }

            let imageKind: ProfileServiceModel.UpdateUserImage.Request.ImageKind
            switch uiProperties.selectedImageKind {
            case .avatar:
                imageKind = .avatar
            case .header:
                imageKind = .header
            }
            let _ = try await networkManager.profileService.updateUserImage(req: .init(imageData: imageData, imageKind: imageKind))
        }
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
        var showPopover = false
        var showPhotoPicker = false
        var alert = AlertModel()
        var selectedImage: PhotosPickerItem?
        var inputNickname = ""
        var inputFIO = ""
        var penState: PenState = .initial
        var selectedImageKind: UserImageKind = .avatar
    }

    enum Screens: Hashable {
        case addAddress
    }

}

extension SettingsViewModel.UIProperties {

    enum UserImageKind: String, Hashable, CaseIterable {
        case avatar
        case header
    }

    enum PenState: Hashable {
        case initial, updated, failed, loading

        var color: Color {
            switch self {
            case .failed: TLColor<IconPalette>.iconRed.color
            case .updated: .green
            case .initial: TLColor<IconPalette>.iconPrimary.color
            case .loading: .orange
            }
        }
    }

}

// MARK: - Setter

extension SettingsViewModel {
    func setCoordinator(_ coordinator: Coordinator, _ startScreenControl: StartScreenControl) {
        self.coordinator = coordinator
        self.startScreenControl = startScreenControl
        uiProperties.inputNickname = userModel.nickname
        uiProperties.inputFIO = userModel.fio ?? ""
    }
}
