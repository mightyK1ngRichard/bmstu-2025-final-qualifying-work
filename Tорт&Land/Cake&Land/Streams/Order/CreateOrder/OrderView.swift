//
//  OrderView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem
import Core
import NetworkAPI

struct OrderView: View {
    @State var viewModel: OrderViewModel
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        List {
            Section("Cake") {
                TLProductHCard(configuration: viewModel.configureProductCard())
                    .listRowInsets(.init())
            }

            Section("Cake Fillings") {
                cakeFillingsContainer
                    .listRowInsets(.init())
                    .listRowBackground(Constants.rowColor)
            }

            Section("Cake parameters") {
                cakeParametersContainer
                    .listRowBackground(Constants.rowColor)
            }

            Section("Order address") {
                addressContainer
                    .listRowBackground(Constants.rowColor)
            }

            Section("Order information") {
                orderInformationContainer
                    .listRowBackground(Constants.rowColor)
            }

            makeOrderButton
        }
        .scrollContentBackground(.hidden)
        .fullScreenCover(isPresented: $viewModel.uiProperties.openSuccessScreen) {
            viewModel.assemblySuccessView()
        }
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .overlay {
            if viewModel.uiProperties.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView().tint(.white)
            }
        }
        .defaultAlert(
            errorContent: viewModel.uiProperties.alert.content,
            isPresented: $viewModel.uiProperties.alert.isShown
        )
        .onFirstAppear {
            viewModel.setCoordinator(coordinator)
            viewModel.onAppear()
        }
        .navigationDestination(for: OrderModel.Screens.self) { screen in
            switch screen {
            case .addAddress:
                viewModel.assemblyAddAddressView()
            case let .updateAddress(selectedAddress):
                viewModel.assemblyUpdateAddressView(address: selectedAddress)
            }
        }
    }
}

// MARK: - UI Subviews

private extension OrderView {

    // MARK: Fillings Row

    var cakeFillingsContainer: some View {
        ScrollView(.horizontal) {
            HStack {
                if let cake = viewModel.cake {
                    ForEach(cake.fillings) { filling in
                        TLImageView(configuration: .init(imageState: filling.imageState))
                            .frame(width: 170, height: 100)
                            .overlay(alignment: .bottom) {
                                Text(filling.name)
                                    .style(11, .regular)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity)
                                    .background(TLColor<BackgroundPalette>.bgMainColor.color)
                            }
                            .overlay {
                                if filling.id == viewModel.uiProperties.selectedFillingID {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 2)
                                        .fill(.green)
                                }
                            }
                            .clipShape(.rect(cornerRadius: 8))
                    }
                } else {
                    ForEach(0..<5) { _ in
                        ShimmeringView(kind: .inverted)
                            .frame(width: 150, height: 100)
                            .clipShape(.rect(cornerRadius: 8))
                    }
                }
            }
            .padding(6)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: Cake Parameters Row

    @ViewBuilder
    var cakeParametersContainer: some View {
        if let cake = viewModel.cake {
            cakeFillingContainer(cake: cake)
            weihtContainer(cake: cake)
        }
    }

    func cakeFillingContainer(cake: CakeModel) -> some View {
        Picker("Cake filling:", selection: $viewModel.uiProperties.selectedFillingID) {
            ForEach(cake.fillings) { filling in
                Text(filling.name)
                    .tag(filling.id)
            }
        }
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(Constants.textSecondaryColor)
    }

    func weihtContainer(cake: CakeModel) -> some View {
        Picker("Cake weight:", selection: $viewModel.uiProperties.selectedWeightMultiplier) {
            ForEach(viewModel.availableMultipliers, id: \.self) { multiplier in
                Text(
                    viewModel.configureWeightCellTitle(
                        multiplier: multiplier,
                        mass: cake.mass
                    )
                )
                .tag(multiplier)
            }
        }
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(Constants.textSecondaryColor)
    }

    // MARK: Order Address Row

    @ViewBuilder
    var addressContainer: some View {
        if let selectedAddress = viewModel.selectedAddress, !viewModel.addresses.isEmpty {
            addressPicker
            addressInfo(selectedAddress: selectedAddress)
        }

        Button {
            viewModel.didTapAddAddress()
        } label: {
            HStack {
                Text("Add address")
                    .style(14, .medium)
                Image(systemName: "plus")
            }
            .foregroundStyle(TLColor<IconPalette>.iconPrimary.color)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    var addressPicker: some View {
        Picker("Shipping Address:", selection: $viewModel.uiProperties.selectedAddressID) {
            ForEach(viewModel.addresses, id: \.id) { address in
                Text(address.formattedAddress)
                    .tag(address.id)
            }
        }
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(Constants.textSecondaryColor)
        .onChange(of: viewModel.uiProperties.selectedAddressID ?? "") { oldValue, newValue in
            guard oldValue != newValue else { return }
            viewModel.updateAddressSelection(id: newValue)
        }
    }

    @ViewBuilder
    func addressInfo(selectedAddress: AddressEntity) -> some View {
        if viewModel.addressIsCorrect {
            addressCell(title: String(localized: "Entrance:"), info: selectedAddress.entrance)
            addressCell(title: String(localized: "Floor:"), info: selectedAddress.floor)
            addressCell(title: String(localized: "Apartment:"), info: selectedAddress.apartment)
            addressCell(title: String(localized: "Comment for delivery:"), info: selectedAddress.comment)
        }

        linkButton(String(localized: "Update address details")) {
            viewModel.didTapUpdateAddress(address: selectedAddress)
        }
    }

    func addressCell(title: String, info: String?) -> some View {
        HStack {
            Text(title)
                .style(14, .regular, Constants.textSecondaryColor)
            Spacer()
            Text(info ?? "")
                .style(14, .medium)
        }
    }

    // MARK: Order Information

    @ViewBuilder
    var orderInformationContainer: some View {
        Picker("Payment Type", selection: $viewModel.uiProperties.paymentMethod) {
            ForEach(PaymentMethod.allCases, id: \.self) { method in
                Text(method.localizedName.capitalized)
            }
        }
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(Constants.textSecondaryColor)

        DatePicker(
            "Desired delivery date:",
            selection: $viewModel.uiProperties.deliveryDate,
            in: (Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date())...,
            displayedComponents: [.date]
        )
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(Constants.textSecondaryColor)

        HStack {
            Text("Total Amount:")
                .style(14, .regular, Constants.textSecondaryColor)
            Spacer()
            Text(viewModel.calculateTotalAmountTitle())
                .style(16, .semibold, TLColor<TextPalette>.textWild.color)
        }
    }

    var makeOrderButton: some View {
        TLButton(String(localized: "make order").uppercased(), action: viewModel.didTapMakeOrder)
            .listRowInsets(.init())
            .listRowBackground(Color.clear)
            .disabled(viewModel.orderIsDisabled)
    }

    func linkButton(_ title: String, action: TLVoidBlock?) -> some View {
        Button {
            action?()
        } label: {
            HStack {
                Text(title)
                    .style(14, .regular)
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 12)
            }
            .foregroundStyle(Constants.textSecondaryColor)
        }
    }

}

// MARK: - Constants

private extension OrderView {
    enum Constants {
        static let textSecondaryColor = TLColor<TextPalette>.textSecondary.color
        static let rowColor = TLColor<BackgroundPalette>.bgTextField.color
    }
}

// MARK: - Preview

#Preview {
    OrderAssembler.assemble(
        cakeID: "550e8400-e29b-41d4-a716-446655441202",
        networkManager: NetworkManager(),
        imageProvider: ImageLoaderProviderImpl()
    )
    .environment(Coordinator())
}
