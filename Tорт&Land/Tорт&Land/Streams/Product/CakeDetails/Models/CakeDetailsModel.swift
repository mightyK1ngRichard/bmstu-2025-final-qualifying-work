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
        var showSheet = false
        var show3DModelScreen = false
        var openFileDirecatory = false
        var selectedFilling: Filling?
        var selectedFileURL: URL?
    }
}

extension CakeDetailsModel {
    enum Screens: Hashable {
        case ratingReviews
    }
}
