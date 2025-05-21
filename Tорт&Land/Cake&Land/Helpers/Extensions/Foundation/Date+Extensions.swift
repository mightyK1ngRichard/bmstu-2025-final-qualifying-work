//
//  Date+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//

import Foundation

extension Date {
    private static let formatters: [String: DateFormatter] = {
        var dict: [String: DateFormatter] = [:]

        let formats = ["dd-MM-yyyy", "HH:mm", "dd-MM-yyyy HH:mm"]
        for format in formats {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            dict[format] = formatter
        }

        return dict
    }()

    func formattedString(format: String) -> String {
        guard let formatter = Date.formatters[format] else {
            let df = DateFormatter()
            df.dateFormat = format
            return df.string(from: self)
        }
        return formatter.string(from: self)
    }

    var formattedHHmm: String {
        formattedString(format: "HH:mm")
    }

    var formattedDDMMYYYY: String {
        formattedString(format: "dd-MM-yyyy")
    }

    var formattedDDMMYYYYHHmm: String {
        formattedString(format: "dd-MM-yyyy HH:mm")
    }
}
