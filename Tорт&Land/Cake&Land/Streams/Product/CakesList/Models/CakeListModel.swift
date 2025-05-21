//
//  CakeListModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation
import NetworkAPI

enum CakesListModel {}

extension CakesListModel {

    struct BindingData: Hashable {
        var screenState: ScreenState = .initial
        let allSections: [SectionKind] = [.sale, .new, .all]
    }

    enum SectionKind: Identifiable, Hashable {
        case all, sale, new
    }

    enum Screens: Hashable {
        case grid([CakeModel])
    }

}

// MARK: - Section Kind

extension CakesListModel.SectionKind {

    var id: String { String(describing: self) }

    var title: LocalizedStringResource {
        switch self {
        case .new:
            return "New"
        case .sale:
            return "Sale"
        case .all:
            return "All"
        }
    }

    var subtitle: LocalizedStringResource {
        switch self {
        case .new:
            return "You’ve never seen it before!"
        case .sale:
            return "Super summer sale"
        case .all:
            return "You can buy it right now!"
        }
    }

}
