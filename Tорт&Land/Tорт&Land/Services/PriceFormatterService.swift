//
//  PriceFormatterService.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 18.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

final class PriceFormatterService {
    static let shared = PriceFormatterService()
    private let formatter: NumberFormatter

    private init() {
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
    }

    func formatPrice(_ price: Double) -> String {
        formatter.minimumFractionDigits = price.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        guard let formattedPrice = formatter.string(from: NSNumber(value: price)) else {
            return "\(price) ₽"
        }

        return "\(formattedPrice) ₽"
    }

    func formatKgPrice(_ price: Double) -> String {
        let formattedPrice = formatPrice(price)
        return "\(formattedPrice)/кг"
    }
}
