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

    enum SortMode: String, Hashable, CaseIterable, Identifiable {
        case none = "Без сортировки"
        case priceAsc = "По возрастанию цены"
        case priceDesc = "По убыванию цены"
        case dateNewest = "Сначала новые"
        case dateOldest = "Сначала старые"

        var id: String { rawValue }
    }
}

// MARK: - SectionKind

extension ProductsGridModel.SectionKind {
    var listSection: CakesListModel.Section {
        switch self {
        case .new:
            return .new([])
        case .sales:
            return .sale([])
        case .default:
            return .all([])
        }
    }
}
