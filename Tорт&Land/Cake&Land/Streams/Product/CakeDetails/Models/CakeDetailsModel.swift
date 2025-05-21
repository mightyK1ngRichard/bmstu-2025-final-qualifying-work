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
        var show3DButton = true
        var showOwnerButton = false
        var showSheet = false
        var openFileDirecatory = false
        var selectedFilling: Filling?
        var selectedFileURL: URL?
        var visableButtonIsLoading = false
        var alert = AlertModel()
    }
}

extension CakeDetailsModel {
    enum Screens: Hashable {
        case ratingReviews
        case arQuickView(remoteURL: URL)
    }
}
