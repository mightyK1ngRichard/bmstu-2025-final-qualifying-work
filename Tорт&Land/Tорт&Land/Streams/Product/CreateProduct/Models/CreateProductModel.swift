//
//  CreateProductModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum CreateProductModel {}

extension CreateProductModel {
    struct UIProperties: Hashable {
        var currentPage = 1
        var inputName = ""
        var inputDescription = ""
        var inputPrice = ""
        var inputMass = ""
        var inputDiscountedPrice = ""
        var alertTitle = ""
        var alertMessage = ""
        var selectedPhotosData: [Data] = []
        var showAlert = false
        var discountEndDate = Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
        let totalCount = 4

        var nextButtonIsEnabled: Bool {
            (
                !inputName.isEmpty
                && !inputDescription.isEmpty
                && !inputMass.isEmpty
                && !inputPrice.isEmpty
                && currentPage == 1
            )
            || currentPage == 2
            || currentPage == 3 && !selectedPhotosData.isEmpty
            || currentPage == 4
        }
    }
}
