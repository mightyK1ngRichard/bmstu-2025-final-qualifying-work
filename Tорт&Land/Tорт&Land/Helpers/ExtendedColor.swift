//
//  ExtendedColor.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 28.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import UIKit
import ColorThiefSwift

func extractPaletteHexColors(from image: UIImage, colorCount: Int = 5) -> [String] {
    guard let palette = ColorThief.getPalette(from: image, colorCount: colorCount) else {
        return []
    }

    return palette.compactMap { $0.makeUIColor().toHexString() }
}
