//
//  ProductsGridModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum ProductsGridModel {}

extension ProductsGridModel {
    struct UIProperties {
    }

    enum SectionKind: Hashable {
        case new
        case sales
        case `default`
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
