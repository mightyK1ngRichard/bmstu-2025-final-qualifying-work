//
//  OrderDetailView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import SwiftUI
import MacCore

struct OrderDetailView: View {
    @State var viewModel: OrderDetailViewModel

    var body: some View {
        contentView
            .onFirstAppear {
                viewModel.fetchCakeByID()
            }
    }
}

private extension OrderDetailView {

    var contentView: some View {
        List {
            orderContainer
            addressContainer
            cakeContainer
        }
        .navigationTitle("Детали заказа")
    }

    @ViewBuilder
    var cakeContainer: some View {
        if let cake = viewModel.cakeModel {
            Section(header: Text("Информация о торте")) {
                // Изображение торта
                ScrollView(.horizontal) {
                    HStack {
                        imageView(imageState: cake.previewImage.imageState)
                        ForEach(cake.thumbnails) { thumbnail in
                            imageView(imageState: thumbnail.imageState)
                        }
                    }
                }
                .padding(.bottom, 16)

                // Название торта
                title("Название торта:") {
                    Text(cake.cakeName)
                }

                // Цена
                title("Цена:") {
                    Text(String(format: "%.1f ₽", cake.kgPrice))
                }

                // Цена со скидкой
                if let discountedPrice = cake.discountedKgPrice {
                    title("Цена со скидкой:") {
                        Text(String(format: "%.1f ₽", discountedPrice))
                    }
                }

                // Масса
                title("Масса:") {
                    Text(String(format: "%.1f г", cake.mass))
                }

                // Рейтинг
                title("Рейтинг:") {
                    Text("\(cake.rating)/5")
                }

                title("Отзывов:") {
                    Text("\(cake.reviewsCount) шт.")
                }

                // Описание
                VStack(alignment: .leading, spacing: 8) {
                    Text("Описание:")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(cake.description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                }
            }

            userContainer(user: cake.seller)
        }
    }

    func imageView(imageState: ImageState) -> some View {
        TLImageView(configuration: .init(imageState: imageState))
            .frame(width: 150, height: 150)
            .cornerRadius(16)
            .shadow(radius: 8)
    }

    @ViewBuilder
    var orderContainer: some View {
        Section(header: Text("Информация о заказе")) {
            // ID заказа
            title("ID:") {
                Text("\(viewModel.order.id)")
            }

            // Общая сумма
            title("Общая сумма:") {
                Text(String(format: "%.2f ₽", viewModel.order.totalPrice))
            }

            // Дата доставки
            title("Дата доставки:") {
                Text("\(viewModel.order.deliveryDate.formatted(date: .abbreviated, time: .omitted))")
            }

            // Метод оплаты
            title("Метод оплаты:") {
                Text(viewModel.order.paymentMethod.rawValue == 0 ? "Наличные" : "Карты")
            }

            // Статус заказа
            title("Статус заказа:") {
                Text(viewModel.order.status.title.capitalized)
                    .foregroundColor(viewModel.order.status.textColor)
            }
        }
    }

    @ViewBuilder
    func userContainer(user: UserModel) -> some View {
        Section(header: Text("Информация о владельце")) {
            // Аватар пользователя
            TLImageView(configuration: .init(imageState: user.avatarImage.imageState))
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 10)
                .frame(maxWidth: .infinity)
                .padding()

            // ID пользователя
            title("ID:") {
                Text(user.id)
            }

            // Полное имя
            if let fio = user.fio {
                title("Полное имя:") {
                    Text(fio)
                }
            }

            // Никнейм
            title("Никнейм:") {
                Text(user.nickname)
            }

            // Электронная почта
            HStack(alignment: .top) {
                Text("Электронная почта:")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(user.mail)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let url = URL(string: "mailto:\(user.mail)") {
                            NSWorkspace.shared.open(url)
                        }
                    }
            }
        }
    }

    var addressContainer: some View {
        Section(header: Text("Адрес доставки")) {
            title("Адрес:") {
                Text(viewModel.order.deliveryAddress.formattedAddress)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            if let apartment = viewModel.order.deliveryAddress.apartment {
                title("Квартира:") {
                    Text(apartment)
                }
            }

            if let entrance = viewModel.order.deliveryAddress.entrance {
                title("Подъезд:") {
                    Text(entrance)
                }
            }

            if let floor = viewModel.order.deliveryAddress.floor {
                title("Этаж:") {
                    Text(floor)
                }
            }

            if let comment = viewModel.order.deliveryAddress.comment {
                title("Комментарий:") {
                    Text(comment)
                }
            }

            title("Координаты:") {
                Text("Ширина: \(viewModel.order.deliveryAddress.latitude)\nДолгота: \(viewModel.order.deliveryAddress.longitude)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    func title<Content: View>(_ title: String, content: () -> Content) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            content()
                .textSelection(.enabled)
                .foregroundColor(.primary)
        }
        .padding(.bottom, 6)
    }

}

// MARK: - Preview

#Preview {
    OrderDetailAssembler.assemble(
        order: CommonMock.orderMock,
        networkManager: NetworkManager(),
        imageProvider: ImageLoaderProviderImpl()
    )
    .frame(width: 500, height: 400)
}
