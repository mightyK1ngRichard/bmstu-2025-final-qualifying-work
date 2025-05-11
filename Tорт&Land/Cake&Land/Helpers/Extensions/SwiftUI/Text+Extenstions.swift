//
//  Text+Extenstions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem

extension Text {

    func style(
        _ size: CGFloat,
        _ weight: Font.Weight,
        _ color: Color = TLColor<TextPalette>.textPrimary.color
    ) -> some View {
        font(.system(size: size, weight: weight))
            .foregroundStyle(color)
    }
}
