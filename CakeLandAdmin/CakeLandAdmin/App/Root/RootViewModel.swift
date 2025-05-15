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
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService

    init(
        networkManager: NetworkManager,
        imageProvider: ImageLoaderProviderImpl,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.networkManager = networkManager
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter

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
                        content: AlertContent(
                            title: "Session Expired",
                            message: "Your session has expired. Please log in again to continue."
                        ),
                        isShown: true
                    )

                    updateStartScreenKind(.needAuth)
                }
            } catch {
                bindingData.alert = AlertModel(content: error.readableGRPCContent, isShown: true)
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
                bindingData.alert = AlertModel(content: error.readableGRPCContent, isShown: true)
            }
            
            bindingData.signInButtonIsLoading = false
        }
    }

    func didTapLogout() {
        Task { @MainActor in
            do {
                try await networkManager.authService.logout()
            } catch {
                bindingData.alert = AlertModel(content: error.readableGRPCContent, isShown: true)
            }
            bindingData.startScreenKind = .needAuth
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.startScreenKind.rawValue)
        }
    }

}

// MARK: - Screens

extension RootViewModel {

    func assembleOrderListViwe() -> OrderListView {
        OrdersListAssembler.assemble(
            networkManager: networkManager,
            imageProvider: imageProvider
        )
    }

    func assembleCategoriesView() -> CategoriesView {
        CategoriesAssembler.assemble(
            networkManager: networkManager,
            imageProvider: imageProvider,
            priceFormatter: priceFormatter
        )
    }

    func assembleCakesList() -> CakeListView {
        CakeListAssembler.assemble(
            networkManager: networkManager,
            imageProvider: imageProvider
        )
    }

    func assembleProfile() -> ProfileView {
        ProfileAssembler.assemble(
            networkManager: networkManager,
            imageProvider: imageProvider
        )
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
