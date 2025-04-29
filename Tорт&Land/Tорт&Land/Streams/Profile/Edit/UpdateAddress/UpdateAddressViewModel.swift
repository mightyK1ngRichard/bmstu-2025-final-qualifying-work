//
//  UpdateAddressViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Observation
import NetworkAPI

@Observable
final class UpdateAddressViewModel {
    var uiProperties = UpdateAddressModel.UIProperties()
    var address: AddressEntity
    var completion: (@MainActor (AddressEntity) -> Void)?
    @ObservationIgnored
    private var coordinator: Coordinator?
    @ObservationIgnored
    private let profileProvider: ProfileGrpcService

    init(
        address: AddressEntity,
        profileProvider: ProfileGrpcService,
        completion: (@MainActor (AddressEntity) -> Void)? = nil
    ) {
        self.address = address
        self.profileProvider = profileProvider
        self.completion = completion
    }
}

extension UpdateAddressViewModel {

    func onAppear() {
        uiProperties.inputEntrance = address.entrance ?? ""
        uiProperties.inputFloor = address.floor ?? ""
        uiProperties.inputApartment = address.apartment ?? ""
        uiProperties.inputComment = address.comment ?? ""
    }

    func saveButtonConfiguration() -> TLButton.Configuration {
        let title = "save".capitalized
        if uiProperties.buttonIsLoading {
            return .init(title: title, kind: .loading)
        }

        return .init(title: title, kind: .default)
    }

    func setCoordinator(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

}

// MARK: - Actions

extension UpdateAddressViewModel {

    func didTapSaveButton() {
        uiProperties.buttonIsLoading = true
        Task { @MainActor in
            do {
                let res = try await profileProvider.updateUserAddress(
                    req: .init(
                        addressID: address.id,
                        entrance: uiProperties.inputEntrance.convertToNilIfEmpty(),
                        floor: uiProperties.inputFloor.convertToNilIfEmpty(),
                        apartment: uiProperties.inputApartment.convertToNilIfEmpty(),
                        comment: uiProperties.inputComment.convertToNilIfEmpty()
                    )
                )
                uiProperties.buttonIsLoading = false

                completion?(res.address)
                coordinator?.openPreviousScreen()
            } catch {
                uiProperties.buttonIsLoading = false
                uiProperties.errorMessage = "\(error)"
            }
        }
    }

}

private extension String {

    func convertToNilIfEmpty() -> String? {
        guard !isEmpty else {
            return nil
        }

        return self
    }
}
