//
//  ProductsGridModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import SwiftUI

enum ProductsGridModel {}

extension ProductsGridModel {
    struct UIProperties: Hashable {
        var selectedSortMode: SortMode = .none
        var bottomSheetKind: BottomSheetKind = .filter
        var showBottomSheet = false
        var showFilterLoader = false
        var priceRange = 0.0
        var maxPrice = 0.0
        var sortModes: [SortMode] = SortMode.allCases
    }

    struct ColorCell: Hashable, Identifiable {
        let hex: String
        let uiColor: UIColor

        var id: String { hex }
    }

    enum SectionKind: Hashable {
        case new
        case sales
        case `default`
    }

    enum BottomSheetKind: Hashable {
        case filter
        case sort
    }

    enum SortMode: Hashable, CaseIterable, Identifiable {
        case none
        case priceAsc
        case priceDesc
        case dateNewest
        case dateOldest

        var id: String { String(describing: self) }

        var title: String {
            switch self {
            case .none:
                return String(localized: "No sorting")
            case .priceAsc:
                return String(localized: "Price: Low to High")
            case .priceDesc:
                return String(localized: "Price: High to Low")
            case .dateNewest:
                return String(localized: "Newest First")
            case .dateOldest:
                return String(localized: "Oldest First")
            }
        }
    }
}
