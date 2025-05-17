//
//  OrderDetailsView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 10.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI
import DesignSystem

struct OrderDetailsView: View {
    @State var viewModel: OrderDetailsViewModel

    var body: some View {
        orderContainer
            .scrollContentBackground(.hidden)
            .background(TLColor<BackgroundPalette>.bgMainColor.color)
            .onFirstAppear {
                viewModel.fetchCakeData()
            }
    }
}

// MARK: - UI Subviews

private extension OrderDetailsView {

    var orderContainer: some View {
        List {
            Group {
                orderInfo
                cakeContainer
                fillingInfo
                addressInfo
                timeInfo
            }
            .listRowBackground(TLColor<BackgroundPalette>.bgTextField.color)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    var orderInfo: some View {
        Section("Order information") {
            HStack {
                Text("Order ID")
                Spacer()
                Text(viewModel.orderEntity.id)
                    .style(12, .regular, TLColor<TextPalette>.textSecondary.color)
                    .multilineTextAlignment(.trailing)
                    .contextMenu {
                        Button(action: viewModel.copyOrderID) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
            }

            HStack {
                Text("Status")
                Spacer()
                Text(viewModel.orderEntity.status.title.capitalized)
                    .foregroundStyle(viewModel.orderEntity.status.textColor)
                    .bold()
            }

            HStack {
                Text("Mass")
                Spacer()
                Text("\(viewModel.orderEntity.mass, specifier: "%.0f") g")
            }

            HStack {
                Text("Total price")
                Spacer()
                Text("\(viewModel.orderEntity.totalPrice, specifier: "%.2f") ₽")
            }

            HStack {
                Text("Payment")
                Spacer()
                Text(viewModel.orderEntity.paymentMethod == .cash ? "Cash" : "YoMoney")
            }
        }
    }

    var addressInfo: some View {
        Section("Delivery") {
            Text(viewModel.orderEntity.deliveryAddress.formattedAddress)

            if let entrance = viewModel.orderEntity.deliveryAddress.entrance {
                HStack {
                    Text("Entrance")
                    Spacer()
                    Text(entrance)
                }
            }
            if let floor = viewModel.orderEntity.deliveryAddress.floor {
                HStack {
                    Text("Floor")
                    Spacer()
                    Text(floor)
                }
            }
            if let apartment = viewModel.orderEntity.deliveryAddress.apartment {
                HStack {
                    Text("Apartment")
                    Spacer()
                    Text(apartment)
                }
            }
            if let comment = viewModel.orderEntity.deliveryAddress.comment {
                HStack {
                    Text("Shipping comment")
                    Spacer()
                    Text(comment)
                }
            }

            HStack {
                Text("Date")
                Spacer()
                Text(
                    viewModel.orderEntity.deliveryDate.formatted(
                        date: .abbreviated, time: .shortened
                    )
                )
            }
        }
    }

    var fillingInfo: some View {
        Section("Filling") {
            HStack {
                Text("Name")
                Spacer()
                Text(viewModel.orderEntity.filling.name)
            }

            HStack {
                Text("Composition")
                Spacer()
                Text(viewModel.orderEntity.filling.content)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Price per kg")
                Spacer()
                Text("\(viewModel.orderEntity.filling.kgPrice, specifier: "%.2f") ₽")
            }

            Text(viewModel.orderEntity.filling.description)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }

    var timeInfo: some View {
        Section("Timestamps") {
            HStack {
                Text("Created at")
                Spacer()
                Text(viewModel.orderEntity.createdAt.formatted())
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Updated at")
                Spacer()
                Text(viewModel.orderEntity.updatedAt.formatted())
                    .foregroundStyle(.secondary)
            }
        }
    }

    var cakeContainer: some View {
        Section("Cake data") {
            if let cake = viewModel.cakeModel {
                VStack(spacing: 16) {
                    imagesCarousel(cake: cake)
                    TLProductDescriptionView(configuration: viewModel.configureCakeCard(cakeModel: cake))
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
            }
        }
    }

    func imagesCarousel(cake: CakeModel) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                TLImageView(
                    configuration: .init(imageState: cake.previewImageState)
                )
                .frame(width: 275, height: 275)

                ForEach(cake.thumbnails) { thumbnail in
                    TLImageView(
                        configuration: .init(imageState: thumbnail.imageState)
                    )
                    .frame(width: 275, height: 275)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
