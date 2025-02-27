//
//  LimitedTextField+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 06.04.2024.
//

import SwiftUI

extension LimitedTextField {
    struct Configuration {
        var limit: Int
        var tint: Color = .blue
        var autoResizes: Bool = false
        var allowsExcessTyping: Bool = false
        var submitLabel: SubmitLabel = .continue
        var progressConfig: ProgressConfig = .init()
        var borderConfig: BorderConfig = .init()
    }

    struct ProgressConfig {
        var showsRing: Bool = true
        var showsText: Bool = false
        var alignment: HorizontalAlignment = .trailing
    }

    struct BorderConfig {
        var show: Bool = true
        var radius: CGFloat = 12
        var width: CGFloat = 0.8
    }
}
