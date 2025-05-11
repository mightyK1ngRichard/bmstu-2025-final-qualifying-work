//
//  String+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.01.2025.
//

import Foundation

extension String {
    var dateRedescription: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.date(from: self)
    }

    var toCorrectDate: String {
        guard let date = self.dateRedescription else {
            return self
        }
        let dateString = date.formatted(.dateTime.year().day().month(.wide))
        return dateString
    }

}
