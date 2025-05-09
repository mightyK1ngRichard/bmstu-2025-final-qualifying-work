//
//  CreateCakeInfoView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

struct CreateCakeInfoView: View {
    @Bindable var viewModel: CreateProductViewModel
    @FocusState private var focusedField: Field?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Constants.logoImage
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .foregroundStyle(Constants.logoColor)
                    .padding(.bottom)

                priceBlockView
                    .focused($focusedField, equals: .price)
                    .padding(.bottom)

                LimitedTextField(
                    configuration: .init(
                        limit: Constants.priceLimit,
                        tint: TLColor<TextPalette>.textPrimary.color,
                        autoResizes: false,
                        borderConfig: .init(radius: Constants.cornderRadius)
                    ),
                    hint: Constants.productNamePlaceholder,
                    value: $viewModel.uiProperties.inputName
                ) {
                    focusedField = .description
                }
                .fixedSize(horizontal: false, vertical: true)
                .focused($focusedField, equals: .name)

                LimitedTextField(
                    configuration: .init(
                        limit: Constants.descriptionLimit,
                        tint: TLColor<TextPalette>.textPrimary.color,
                        autoResizes: false,
                        borderConfig: .init(radius: Constants.cornderRadius)
                    ),
                    hint: Constants.procductDescriptionPlaceholder,
                    value: $viewModel.uiProperties.inputDescription
                )
                .frame(minHeight: 200, maxHeight: 280)
                .fixedSize(horizontal: false, vertical: true)
                .focused($focusedField, equals: .description)

                Spacer()
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                keyboardToolBarItems
            }
        }
    }
}

// MARK: - UI Subviews

private extension CreateCakeInfoView {

    var priceBlockView: some View {
        VStack(spacing: 20) {
            HStack(alignment: .bottom, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(Constants.pricePlaceholder)
                        .style(11, .regular, TLColor<TextPalette>.textSecondary.color)

                    TextField("1000", text: $viewModel.uiProperties.inputPrice)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .overlay {
                            RoundedRectangle(cornerRadius: Constants.cornderRadius)
                                .stroke(lineWidth: 0.8)
                        }
                        .submitLabel(.done)
                        .focused($focusedField, equals: .price)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(Constants.massPlaceholder)
                        .style(11, .regular, TLColor<TextPalette>.textSecondary.color)

                    TextField("200", text: $viewModel.uiProperties.inputMass)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .overlay {
                            RoundedRectangle(cornerRadius: Constants.cornderRadius)
                                .stroke(lineWidth: 0.8)
                        }
                        .submitLabel(.done)
                        .focused($focusedField, equals: .mass)
                }
            }

            HStack(alignment: .bottom, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(Constants.discountedPriceBar)
                        .style(11, .regular, TLColor<TextPalette>.textSecondary.color)

                    TextField("850", text: $viewModel.uiProperties.inputDiscountedPrice)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .overlay {
                            RoundedRectangle(cornerRadius: Constants.cornderRadius)
                                .stroke(lineWidth: 0.8)
                        }
                        .submitLabel(.done)
                        .focused($focusedField, equals: .discountedPrice)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(Constants.discountedEndDateTitle)
                        .style(11, .regular, TLColor<TextPalette>.textSecondary.color)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .multilineTextAlignment(.trailing)

                    DatePicker(
                        "",
                        selection: $viewModel.uiProperties.discountEndDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                }
            }
        }
    }

    var keyboardToolBarItems: some View {
        HStack {
            Button("Close") {
                focusedField = nil
            }
            Spacer()
            Button {
                switch focusedField {
                case .price:
                    focusedField = .mass
                case .mass:
                    focusedField = .discountedPrice
                case .discountedPrice:
                    focusedField = .name
                case .name:
                    focusedField = .description
                case .description:
                    focusedField = nil
                case .none:
                    focusedField = nil
                }
            } label: {
                Image(systemName: "checkmark")
                    .foregroundStyle(TLColor<IconPalette>.iconRed.color)
            }
        }
    }
}

// MARK: - Field

private extension CreateCakeInfoView {
    enum Field: Int, CaseIterable {
        case name, price, discountedPrice, mass, description
    }
}

// MARK: - Constants

private extension CreateCakeInfoView {
    enum Constants {
        static let cornderRadius: CGFloat = 8
        static let priceLimit = 40
        static let descriptionLimit = 900
        static let pricePlaceholder = String(localized: "*Kg price, \(StringConstants.rub)")
        static let massPlaceholder = String(localized: "*Weight in grams")
        static let productNamePlaceholder = String(localized: "Cake name")
        static let discountedEndDateTitle = String(localized: "Discounted price end date (Optional field)")
        static let procductDescriptionPlaceholder = String(localized: "Write a description of the product...")
        static let discountedPriceBar = String(localized: "Discounted price (Optional field)")
        static let logoImage = Image(uiImage: TLAssets.cakeLogo)
        static let logoColor = TLColor<IconPalette>.iconRed.color.gradient
    }
}
