//
//  NotificationDetailView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension NotificationDetailView {
    var mainContainer: some View {
        List {
            usersSectionBlock
            productSectionBlock
            notificationContentSectionBlock
            deliveryAddressView
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(Constants.navigationTitle)
        .background(Constants.bgColor)
    }
}

// MARK: - UI Subviews

private extension NotificationDetailView {
    var usersSectionBlock: some View {
        switch viewModel.orderData.kind {
        case let .purchase(userModel):
            customerOrSellerCell(
                sectionTitle: Constants.customerSectionTitle,
                rowTitle: userModel.name,
                action: viewModel.didTapCustomerInfo
            )
        case let .sale(userModel):
            customerOrSellerCell(
                sectionTitle: Constants.sellerSectionTitle,
                rowTitle: userModel.name,
                action: viewModel.didTapSellerInfo
            )
        }
    }

    func customerOrSellerCell(
        sectionTitle: String,
        rowTitle: String,
        action: @escaping TLVoidBlock
    ) -> some View {
        Section(sectionTitle) {
            Button(action: action) {
                textChevronCell(title: rowTitle)
            }
        }
        .listRowBackground(Constants.rowColor)
    }

    func textChevronCell(title: String) -> some View {
        HStack {
            Text(title)
                .style(16, .semibold, Constants.textPrimaryColor)
            Spacer()
            Image(systemName: Constants.chevronImg)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .foregroundStyle(Constants.chevronColor)
                .bold()
        }
    }

    @ViewBuilder
    var productSectionBlock: some View {
        Section {
            TLProductDescriptionView(
                configuration: viewModel.configureProductDescriptionConfiguration()
            )
            .padding()
        } header: {
            Text(Constants.productSectionTitle)
                .padding(.leading, 20)
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Constants.rowColor)
    }

    var notificationContentSectionBlock: some View {
        Section(Constants.notificationSectionTitle) {
            Group {
                Text("ID: \(viewModel.orderData.notification.id)")
                    .style(11, .semibold, Constants.textSecondaryColor)

                Text(Constants.orderDate + ": \(viewModel.orderData.notification.date)")
                    .style(14, .semibold, Constants.textPrimaryColor)

                Text(viewModel.orderData.notification.title)
                    .style(18, .semibold, Constants.textPrimaryColor)

                if let message = viewModel.orderData.notification.text {
                    Text(message)
                        .style(14, .regular, Constants.textDescription)
                }
            }
            .listRowBackground(Constants.rowColor)
        }
    }

    var deliveryAddressView: some View {
        Section(Constants.addressSectionTitle) {
            if let address = viewModel.orderData.deliveryAddress {
                Text(address)
                    .style(14, .regular, Constants.textDescription)
                    .listRowBackground(Constants.rowColor)
            } else {
                ContentUnavailableView(
                    Constants.notFoundTitle,
                    systemImage: Constants.photoImg
                )
                .listRowBackground(Constants.rowColor)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NotificationDetailView(
        viewModel: NotificationDetailViewModelMock()
    )
    .environment(Coordinator())
}

// MARK: - Constants

private extension NotificationDetailView {
    enum Constants {
        static let textPrimaryColor = TLColor<TextPalette>.textPrimary.color
        static let textSecondaryColor = TLColor<TextPalette>.textSecondary.color
        static let textDescription = TLColor<TextPalette>.textDescription.color
        static let bgColor = TLColor<BackgroundPalette>.bgMainColor.color
        static let rowColor = TLColor<BackgroundPalette>.bgCommentView.color
        static let chevronColor = TLColor<IconPalette>.iconGray.color
        static let navigationTitle = String(localized: "Order")
        static let customerSectionTitle = String(localized: "Customer")
        static let sellerSectionTitle = String(localized: "Seller")
        static let productSectionTitle = String(localized: "Product")
        static let addressSectionTitle = String(localized: "Delivery address")
        static let notificationSectionTitle = String(localized: "Notification content")
        static let orderDate = String(localized: "Order date")
        static let notFoundTitle = String(localized: "User address not found")
        static let chevronImg = "chevron.right"
        static let photoImg = "photo"
    }
}
