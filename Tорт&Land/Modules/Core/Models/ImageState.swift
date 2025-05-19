//
//  ImageState.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import UIKit

public enum ImageState: Hashable {
    case loading
    case fetched(ImageKind)
    case error(_ urlString: String?, ImageIcon)
    case empty
}

public extension ImageState {
    enum ImageKind: Hashable {
        case uiImage(UIImage)
        case data(Data)
    }

    enum ImageIcon: Hashable {
        case uiImage(UIImage)
        case systemImage(_ systemName: String = "arrow.counterclockwise")
    }
}
