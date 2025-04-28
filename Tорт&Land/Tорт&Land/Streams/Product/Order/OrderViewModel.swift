//
//  OrderViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI

enum PaymentMethod: String, Hashable, CaseIterable {
    case cash
    case ioMoney = "ЮMoney"
}

extension OrderViewModel {
    struct UIProperties: Hashable {
        var state: ScreenState = .initial
        var selectedFillingID = ""
        var selectedAddressID: String?
        var selectedWeightMultiplier = 1.0
        var paymentMethod: PaymentMethod = .cash
        var deliveryDate = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    }

    enum Screens: Hashable {
        case updateAddress(AddressEntity)
        case addAddress
    }
}

@Observable
final class OrderViewModel {
    var uiProperties = UIProperties()
    private(set) var cake: CakeModel?
    private(set) var addresses: [AddressEntity] = []
    private(set) var selectedAddress: AddressEntity?
    private let cakeID: String
    @ObservationIgnored
    let availableMultipliers = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    @ObservationIgnored
    private let imageProvider: ImageLoaderProvider
    @ObservationIgnored
    private let profileProvider: ProfileGrpcService
    @ObservationIgnored
    private let cakeProvider: CakeService
    @ObservationIgnored
    private let priceFormatter: PriceFormatterService
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        cakeID: String,
        profileProvider: ProfileGrpcService,
        cakeProvider: CakeService,
        imageProvider: ImageLoaderProvider,
        priceFormatter: PriceFormatterService = .shared
    ) {
        self.cakeID = cakeID
        self.cakeProvider = cakeProvider
        self.profileProvider = profileProvider
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
                let cakeEntity = try await cakeProvider.fetchCakeDetails(cakeID: cakeID)
                cake = CakeModel(from: cakeEntity)
                fetchCakeImages(fillings: cakeEntity.fillings)
                fetchCakePreview(url: cakeEntity.imageURL)
                uiProperties.selectedFillingID = cakeEntity.fillings.first?.id ?? ""
                uiProperties.state = .finished
            } catch {
                uiProperties.state = .error(message: "\(error)")
            }
        }
    }

    /// Получаем адреса
    func fetchUserAddresses() {
        Task { @MainActor in
            do {
                addresses = try await profileProvider.getUserAddresses()
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
            let createdAddress = try await profileProvider.createAddress(req: req)
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
        print("[DEBUG]: \(#function)")
    }

    func didTapUpdateAddress(address: AddressEntity) {
        coordinator?.addScreen(Screens.updateAddress(address))
    }

    func didTapAddAddress() {
        coordinator?.addScreen(Screens.addAddress)
    }

    func setCoordinator(_ coordinator: Coordinator) {
        self.coordinator = coordinator
    }

}

// MARK: - Configurations

extension OrderViewModel {

    func configureWeightCellTitle(multiplier: Double, mass: Double) -> String {
        let coef = String(format: "%.1f", multiplier)
        return "\(coef)× (\(Int(mass * multiplier)) г)"
    }

    func calculateTotalAmount() -> String {
        guard let cake else {
            return ""
        }

        let kgPrice = cake.discountedPrice ?? cake.price
        let mass = uiProperties.selectedWeightMultiplier * cake.mass
        let total = kgPrice * (mass / 1000)

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
            profileProvider: profileProvider
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

}
