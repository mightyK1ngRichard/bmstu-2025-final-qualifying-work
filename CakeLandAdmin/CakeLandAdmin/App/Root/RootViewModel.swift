//
//  RootViewModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import Observation
import NetworkAPI
import GRPC
import Foundation

@Observable
final class RootViewModel {
    var bindingData: RootModel.BinindingData

    private(set) var profileInfo: ProfileEntity?
    private(set) var cakes: [PreviewCakeEntity] = []
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProviderImpl

    init(networkManager: NetworkManager, imageProvider: ImageLoaderProviderImpl) {
        self.networkManager = networkManager
        self.imageProvider = imageProvider

        bindingData = RootModel.BinindingData()

        if let screenKindString = UserDefaults.standard.string(forKey: UserDefaultsKeys.startScreenKind.rawValue) {
            bindingData.startScreenKind = StartScreenKind(rawValue: screenKindString) ?? .needAuth
        }
    }
}

// MARK: - Network

extension RootViewModel {

    func fetchUserInfo() {
        Task { @MainActor in
            do {
                let res = try await networkManager.profileService.getUserInfo()
                profileInfo = res.userInfo.profile
            } catch let grpcError as GRPCStatus {
                if grpcError.code == .unauthenticated {
                    bindingData.alert = AlertModel(
                        errorContent: ErrorContent(
                            title: "Session Expired",
                            message: "Your session has expired. Please log in again to continue."
                        ),
                        isShown: true
                    )

                    updateStartScreenKind(.needAuth)
                }
            } catch {
                bindingData.alert = AlertModel(errorContent: error.readableGRPCContent, isShown: true)
            }
        }
    }

}

// MARK: - Actions

extension RootViewModel {

    func didTapSignIn() {
        bindingData.signInButtonIsLoading = true
        Task { @MainActor in
            do {
                let _ = try await networkManager.authService.login(
                    req: .init(
                        email: bindingData.inputEmail,
                        password: bindingData.inputPassword
                    )
                )

                updateStartScreenKind(.authed)
            } catch {
                bindingData.alert = AlertModel(errorContent: error.readableGRPCContent, isShown: true)
            }
            
            bindingData.signInButtonIsLoading = false
        }
    }

}

// MARK: - Screens

extension RootViewModel {

    func assembleOrderListViwe() -> OrderListView {
        OrdersListAssembler.assemble(networkManager: networkManager, imageProvider: imageProvider)
    }

}

// MARK: - Helpers

extension RootViewModel {

    @MainActor
    func updateStartScreenKind(_ kind: StartScreenKind) {
        bindingData.startScreenKind = kind
        UserDefaults.standard.set(kind.rawValue, forKey: UserDefaultsKeys.startScreenKind.rawValue)
    }

}
