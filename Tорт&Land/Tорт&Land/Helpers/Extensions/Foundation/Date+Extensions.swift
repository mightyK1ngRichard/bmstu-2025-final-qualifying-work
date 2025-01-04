//
//  Date+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//

import Foundation

extension Date {
    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    var formattedHHmm: String {
        formattedString(format: "HH:mm")
    }
}
