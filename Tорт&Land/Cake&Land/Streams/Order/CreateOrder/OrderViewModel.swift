//
//  OrderViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI
import DesignSystem

@Observable
final class OrderViewModel {
    var uiProperties = OrderModel.UIProperties()
    private(set) var cake: CakeModel?
    private(set) var addresses: [AddressEntity] = []
    private(set) var selectedAddress: AddressEntity?
    private let cakeID: String
    @ObservationIgnored
    let availableMultipliers = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        cakeID: String,
        networkManager: NetworkManager,
        imageProvider: ImageLoaderProvider,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.cakeID = cakeID
        self.networkManager = networkManager
        self.imageProvider = imageProvider
        self.priceFormatter = priceFormatter
    }

    var addressIsCorrect: Bool {
        selectedAddress?.apartment != nil
        || selectedAddress?.entrance != nil
        || selectedAddress?.floor != nil
    }

    var orderIsDisabled: Bool {
        !addressIsCorrect
        || uiProperties.selectedAddressID == nil
        || uiProperties.selectedFillingID.isEmpty
    }
}

extension OrderViewModel {

    func onAppear() {
        uiProperties.selectedWeightMultiplier = availableMultipliers.first ?? 1
        fetchCakeInfo()
        fetchUserAddresses()
    }

    /// Получаем информацию торта
    func fetchCakeInfo() {
        uiProperties.state = .loading
        Task { @MainActor in
            do {
                let res = try await networkManager.cakeService.fetchCakeByID(cakeID: cakeID)
                cake = CakeModel(from: res.cake)
                fetchCakeImages(fillings: res.cake.fillings)
                fetchCakePreview(url: res.cake.imageURL)
                uiProperties.selectedFillingID = res.cake.fillings.first?.id ?? ""
                uiProperties.state = .finished
            } catch {
                uiProperties.state = .error(content: error.readableGRPCContent)
            }
        }
    }

    /// Получаем адреса
    func fetchUserAddresses() {
        Task { @MainActor in
            do {
                addresses = try await networkManager.profileService.getUserAddresses()
                let address = addresses.first
                uiProperties.selectedAddressID = address?.id
                selectedAddress = address
            } catch {

            }
        }
    }

    /// Создаём адрес
    func createAddress(req: ProfileServiceModel.CreateAddress.Request) {
        Task { @MainActor in
            let createdAddress = try await networkManager.profileService.createAddress(req: req)
            addresses.append(createdAddress)
            uiProperties.selectedAddressID = createdAddress.id
            selectedAddress = createdAddress
        }
    }

    /// Получаем фотографии торта
    private func fetchCakeImages(fillings: [FillingEntity]) {
        for (index, filling) in fillings.enumerated() {
            Task { @MainActor in
                let imageState = await imageProvider.fetchImage(for: filling.imageURL)
                cake?.fillings[index].imageState = imageState
            }
        }
    }

    /// Получаем превью торта
    private func fetchCakePreview(url: String) {
        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: url)
            cake?.previewImageState = imageState
        }
    }

}

// MARK: - Actions

extension OrderViewModel {

    /// Обновляем выбранные адрес
    func updateAddressSelection(id: String) {
        selectedAddress = addresses.first { $0.id == id }
    }
    
    /// Нажали кнопку `Заказать торт`
    func didTapMakeOrder() {
        guard
            let cake,
            let totalAmount = calculateTotalAmount,
            let selectedAddressID = uiProperties.selectedAddressID,
            !uiProperties.selectedFillingID.isEmpty
        else {
            uiProperties.alert = .init(
                errorContent: ErrorContent(
                    title: StringConstants.invalidInputData,
                    message: StringConstants.formFieldsMissingError
                ),
                isShown: true
            )
            return
        }

        uiProperties.isLoading = true
        Task { @MainActor in
            do {
                let _ = try await networkManager.orderService.makeOrder(
                    req: .init(
                        totalPrice: totalAmount,
                        deliveryAddressID: selectedAddressID,
                        mass: uiProperties.selectedWeightMultiplier * cake.mass,
                        paymentMethod: PaymentMethodEntity(from: uiProperties.paymentMethod),
                        deliveryDate: uiProperties.deliveryDate,
                        fillingID: uiProperties.selectedFillingID,
                        sellerID: cake.seller.id,
                        cakeID: cakeID
                    )
                )
                uiProperties.isLoading = false
                uiProperties.openSuccessScreen = true
            } catch {
                uiProperties.isLoading = false
                uiProperties.alert = .init(
                    errorContent: error.readableGRPCContent,
                    isShown: true
                )
            }
        }
    }

    func didTapUpdateAddress(address: AddressEntity) {
        coordinator?.addScreen(OrderModel.Screens.updateAddress(address))
    }

    func didTapAddAddress() {
        coordinator?.addScreen(OrderModel.Screens.addAddress)
    }

    func setCoordinator(_ coordinator: Coordinator) {
        self.coordinator = coordinator
    }

}

// MARK: - Configurations

extension OrderViewModel {

    func configureWeightCellTitle(multiplier: Double, mass: Double) -> String {
        let coef = String(format: "%.1f", multiplier)
        return "\(coef)× (\(Int(mass * multiplier)) g)"
    }

    var calculateTotalAmount: Double? {
        guard let cake else {
            return nil
        }

        let kgPrice = cake.discountedPrice ?? cake.price
        let mass = uiProperties.selectedWeightMultiplier * cake.mass
        return kgPrice * (mass / 1000)
    }

    func calculateTotalAmountTitle() -> String {
        guard let total = calculateTotalAmount else {
            return ""
        }

        return priceFormatter.formatPrice(total)
    }

    func configureProductCard() -> TLProductHCard.Configuration {
        guard let cake else {
            return .shimmering
        }

        return cake.configureProductHCard(priceFormatter: priceFormatter)
    }

}

// MARK: - Screens

extension OrderViewModel {

    func assemblyUpdateAddressView(address: AddressEntity) -> UpdateAddressView {
        let viewModel = UpdateAddressViewModel(
            address: address,
            profileProvider: networkManager.profileService
        ) { [weak self] updatedAddress in
            self?.selectedAddress = updatedAddress
        }

        return UpdateAddressView(viewModel: viewModel)
    }

    func assemblyAddAddressView() -> UserLocationView {
        let viewModel = UserLocationViewModel { [weak self] placemark in
            guard let self else { return }
            createAddress(
                req: .init(
                    latitude: placemark.coordinate.latitude,
                    longitude: placemark.coordinate.longitude,
                    formattedAddress: placemark.title ?? "\(placemark.coordinate)"
                )
            )
        }

        return UserLocationView(viewModel: viewModel)
    }

    func assemblySuccessView() -> OrderSuccessView {
        OrderSuccessView { [weak self] in
            self?.coordinator?.goToRoot()
        }
    }

}
