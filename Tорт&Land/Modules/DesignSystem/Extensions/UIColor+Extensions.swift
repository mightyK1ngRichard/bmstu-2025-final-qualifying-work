//
//  UIColor+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import UIKit

public extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if formatted.hasPrefix("#") {
            formatted.removeFirst()
        }

        guard formatted.count == 6 else {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: formatted).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }

    func toHexString() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }

}

