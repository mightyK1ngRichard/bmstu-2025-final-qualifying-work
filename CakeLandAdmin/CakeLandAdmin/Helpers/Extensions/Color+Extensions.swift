//
//  Color+Extensions.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 13.05.2025.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: UInt64
        (r, g, b, a) = (
            int >> 16,
            int >> 8 & 0xFF,
            int & 0xFF,
            255
        )

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
