//
//  CGFloat+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//

import Foundation

extension CGFloat {
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
