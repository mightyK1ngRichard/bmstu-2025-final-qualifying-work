//
//  EdgeInsets+Hashable.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUICore

extension EdgeInsets: @retroactive Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(leading)
        hasher.combine(trailing)
        hasher.combine(bottom)
    }
}
