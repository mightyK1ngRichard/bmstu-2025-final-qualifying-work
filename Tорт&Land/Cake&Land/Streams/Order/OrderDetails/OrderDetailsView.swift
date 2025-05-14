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
        Section("Информация о заказе") {
            HStack {
                Text("ID заказа")
                Spacer()
                Text(viewModel.orderEntity.id)
                    .style(12, .regular, TLColor<TextPalette>.textSecondary.color)
                    .multilineTextAlignment(.trailing)
                    .contextMenu {
                        Button(action: viewModel.copyOrderID) {
                            Label("Скопировать", systemImage: "doc.on.doc")
                        }
                    }
            }

            HStack {
                Text("Статус")
                Spacer()
                Text(viewModel.orderEntity.status.title.capitalized)
                    .foregroundStyle(viewModel.orderEntity.status.textColor)
                    .bold()
            }

            HStack {
                Text("Масса")
                Spacer()
                Text("\(viewModel.orderEntity.mass, specifier: "%.0f") г")
            }

            HStack {
                Text("Цена")
                Spacer()
                Text("\(viewModel.orderEntity.totalPrice, specifier: "%.2f") ₽")
            }

            HStack {
                Text("Оплата")
                Spacer()
                Text(viewModel.orderEntity.paymentMethod == .cash ? "Наличные" : "IO-деньги")
            }
        }
    }

    var addressInfo: some View {
        Section("Доставка") {
            Text(viewModel.orderEntity.deliveryAddress.formattedAddress)

            if let entrance = viewModel.orderEntity.deliveryAddress.entrance {
                HStack {
                    Text("Подъезд")
                    Spacer()
                    Text(entrance)
                }
            }
            if let floor = viewModel.orderEntity.deliveryAddress.floor {
                HStack {
                    Text("Этаж")
                    Spacer()
                    Text(floor)
                }
            }
            if let apartment = viewModel.orderEntity.deliveryAddress.apartment {
                HStack {
                    Text("Квартира")
                    Spacer()
                    Text(apartment)
                }
            }
            if let comment = viewModel.orderEntity.deliveryAddress.comment {
                HStack {
                    Text("Комментарий")
                    Spacer()
                    Text(comment)
                }
            }

            HStack {
                Text("Дата")
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
        Section("Начинка") {
            HStack {
                Text("Название")
                Spacer()
                Text(viewModel.orderEntity.filling.name)
            }

            HStack {
                Text("Состав")
                Spacer()
                Text(viewModel.orderEntity.filling.content)
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Цена за кг")
                Spacer()
                Text("\(viewModel.orderEntity.filling.kgPrice, specifier: "%.2f") ₽")
            }

            Text(viewModel.orderEntity.filling.description)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }

    var timeInfo: some View {
        Section("Временные метки") {
            HStack {
                Text("Создан")
                Spacer()
                Text(viewModel.orderEntity.createdAt.formatted())
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Обновлён")
                Spacer()
                Text(viewModel.orderEntity.updatedAt.formatted())
                    .foregroundStyle(.secondary)
            }
        }
    }

    var cakeContainer: some View {
        Section("Данные торта") {
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
