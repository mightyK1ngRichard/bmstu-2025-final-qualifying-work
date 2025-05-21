//
//  Text+Ext.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension Text {

    func style(
        _ size: CGFloat,
        _ weight: Font.Weight,
        _ color: Color = Color.textPrimary
    ) -> some View {
        font(.system(size: size, weight: weight))
            .foregroundStyle(color)
    }
}
