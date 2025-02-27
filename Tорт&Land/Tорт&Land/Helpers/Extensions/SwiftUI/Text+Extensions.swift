//
//  Text+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

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
