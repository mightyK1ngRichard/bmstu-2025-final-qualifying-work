//
//  ImageState.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation
import UIKit

enum ImageState: Identifiable, Hashable {
    case loading
    case fetched(ImageKind)
    case error(ImageErrorKind)
    case empty
}

extension ImageState {
    var id: Int {
        UUID().hashValue
    }

    enum ImageKind: Hashable {
        case uiImage(UIImage)
        case data(Data)
    }

    enum ImageErrorKind: Hashable {
        case uiImage(UIImage)
        case systemImage(_ systemName: String = "photo.badge.exclamationmark")
    }
}
