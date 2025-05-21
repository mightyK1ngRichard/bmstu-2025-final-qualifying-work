//
//  LimitedTextField+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 06.04.2024.
//

import SwiftUI

public extension LimitedTextField {
    struct Configuration {
        var limit: Int
        var tint: Color = .blue
        var autoResizes: Bool = false
        var allowsExcessTyping: Bool = false
        var submitLabel: SubmitLabel = .continue
        var progressConfig: ProgressConfig = .init()
        var borderConfig: BorderConfig = .init()

        public init(
            limit: Int,
            tint: Color,
            autoResizes: Bool = false,
            allowsExcessTyping: Bool = false,
            submitLabel: SubmitLabel = .continue,
            progressConfig: ProgressConfig = .init(),
            borderConfig: BorderConfig = .init()
        ) {
            self.limit = limit
            self.tint = tint
            self.autoResizes = autoResizes
            self.allowsExcessTyping = allowsExcessTyping
            self.submitLabel = submitLabel
            self.progressConfig = progressConfig
            self.borderConfig = borderConfig
        }
    }

    struct ProgressConfig {
        var showsRing: Bool = true
        var showsText: Bool = false
        var alignment: HorizontalAlignment = .trailing

        public init(
            showsRing: Bool = true,
            showsText: Bool = false,
            alignment: HorizontalAlignment = .trailing
        ) {
            self.showsRing = showsRing
            self.showsText = showsText
            self.alignment = alignment
        }
    }

    struct BorderConfig {
        var show: Bool = true
        var radius: CGFloat = 12
        var width: CGFloat = 0.8

        public init(
            show: Bool = true,
            radius: CGFloat = 12,
            width: CGFloat = 0.8
        ) {
            self.show = show
            self.radius = radius
            self.width = width
        }
    }
}
