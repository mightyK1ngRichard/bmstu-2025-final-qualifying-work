//
//  CakeDetailsModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 22.12.2024.
//

import Foundation

enum CakeDetailsModel {
    struct BindingData: Hashable {
        var isLoading = false
    }
}

extension CakeDetailsModel {
    enum Screens: Hashable {
        case ratingReviews
    }
}
