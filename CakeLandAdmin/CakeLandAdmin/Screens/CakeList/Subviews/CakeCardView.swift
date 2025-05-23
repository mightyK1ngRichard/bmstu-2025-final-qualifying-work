//
//  CakeCardView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 14.05.2025.
//

import SwiftUI
import AppKit
import Combine

struct CakeCardView: View {
    @Binding var cake: CakeModel
    let changePublisher: PassthroughSubject<CakeModel, Never>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TLImageView(
                configuration: .init(imageState: cake.previewImage.imageState)
            )
            .frame(height: 250)
            .clipShape(.rect(cornerRadius: 12))

            // Название торта
            Text(cake.cakeName)
                .font(.system(size: 20, weight: .semibold))
                .lineLimit(2)

            Text("Продавец: \(cake.seller.titleName)")
            Text("Почта: \(cake.seller.mail)")
                .textSelection(.enabled)

            // Описание торта
            Text(cake.description)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.gray)

            // Рейтинг и количество отзывов
            HStack {
                Text("Рейтинг: \(cake.rating)/5")
                    .font(.subheadline)
                Text("(\(cake.reviewsCount) отзывов)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Цена за килограмм
            Text("Цена за кг: \(cake.kgPrice, specifier: "%.2f") ₽")
                .font(.subheadline)

            // Масса торта
            Text("Масса: \(cake.mass, specifier: "%.2f") г")
                .font(.subheadline)

            // Информация о скидке (если есть)
            if let discountKgPrice = cake.discountedKgPrice, let discountEndTime = cake.discountedEndDate {
                Text("Цена за кг по скидке: \(discountKgPrice, specifier: "%.2f") ( до \(discountEndTime.formattedDDMMYYYYHHmm) )")
                    .font(.subheadline)
            }

            // Сегментированный контрол для смены статуса
            Picker("Статус", selection: $cake.status) {
                ForEach(CakeStatus.allCases, id: \.self) { status in
                    if status != .unspecified {
                        Text(status.title)
                            .tag(status)
                    }
                }
            }
            .pickerStyle(.radioGroup)
        }
        .onChange(of: cake.status) { _, newValue in
            changePublisher.send(cake)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    @Previewable
    @State var cake = CommonMock.cakeMock
    CakeCardView(cake: $cake, changePublisher: PassthroughSubject<CakeModel, Never>())
    .padding()
    .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
    .frame(width: 500, height: 550)
}
#endif
