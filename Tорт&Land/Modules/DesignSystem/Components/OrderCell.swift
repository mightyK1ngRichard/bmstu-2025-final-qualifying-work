//
//  OrderCell.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 08.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

public extension OrderCell {
    struct Configuration: Hashable {
        var title = ""
        var date = ""
        var addressTitle = ""
        var mass = ""
        var totalAmount = ""
        var status: OrderStatus = .pending

        public init(
            title: String = "",
            date: String = "",
            addressTitle: String = "",
            mass: String = "",
            totalAmount: String = "",
            status: OrderStatus = .pending
        ) {
            self.title = title
            self.date = date
            self.addressTitle = addressTitle
            self.mass = mass
            self.totalAmount = totalAmount
            self.status = status
        }
    }

    enum OrderStatus: Sendable, Hashable {
        /// Заказ создан и ожидает обработки.
        case pending
        /// Заказ находится в пути
        case shipped
        /// Заказ был успешно выполнен и доставлен.
        case delivered
        /// Заказ отменён.
        case cancelled
    }
}

public extension OrderCell.OrderStatus {
    var title: String {
        String(describing: self)
    }

    /// Цвет текста статуса
    var textColor: Color {
        switch self {
        case .pending:
            return .orange
        case .shipped:
            return .blue
        case .delivered:
            return .green
        case .cancelled:
            return .red
        }
    }
}

// MARK: - OrderCell

public struct OrderCell: View, Configurable {
    let configuration: Configuration

    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerContainer
            bodyContainer
            footerContainer
        }
        .padding(19)
        .background(TLColor<BackgroundPalette>.bgCommentView.color, in: .rect(cornerRadius: 8))
        .contentShape(.rect)
    }
}

// MARK: - UI Subviews

private extension OrderCell {

    var headerContainer: some View {
        HStack {
            Text(configuration.title)
                .style(16, .semibold)
            Spacer()
            Text(configuration.date)
                .style(14, .regular, Constants.textSecondary)
        }
    }

    var bodyContainer: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 10) {
                Text("Delivery address:")
                    .style(14, .regular, Constants.textSecondary)
                Text(configuration.addressTitle)
                    .style(14, .medium)
            }
            HStack {
                textWithTitle(title: "Mass:", subtitle: configuration.mass, isBold: true)
                Spacer()
                textWithTitle(title: "Total Amount:", subtitle: configuration.totalAmount, isBold: true)
            }
        }
        .padding(.top, 15)
    }

    var footerContainer: some View {
        HStack {
            detailButton
            Spacer()
            Text(configuration.status.title.capitalized)
                .style(14, .medium, configuration.status.textColor)
        }
        .padding(.top, 14)
    }

    func textWithTitle(
        title: String,
        subtitle: String,
        isBold: Bool = false
    ) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(title)
                .style(14, .regular, Constants.textSecondary)
            Text(subtitle)
                .style(isBold ? 14 : 16, isBold ? .medium : .semibold)
        }
    }

    var detailButton: some View {
        Text("Details")
            .padding(.horizontal, 25)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(lineWidth: 1)
            }
    }
}

// MARK: - Preview

#Preview {
    OrderCell(
        configuration: .init(
            title: "Order №1947034",
            date: "05-12-2019",
            addressTitle: "Авиаторов Шоссе, 12",
            mass: "1000 г",
            totalAmount: "1000 ₽",
            status: .pending
        )
    )
    .padding()
}

// MARK: - Constants

private extension OrderCell {
    enum Constants {
        static let textSecondary = TLColor<TextPalette>.textSecondary.color
    }
}
