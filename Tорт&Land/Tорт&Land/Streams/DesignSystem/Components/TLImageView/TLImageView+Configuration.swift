//
//  TLImageView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

extension TLImageView {

    struct Configuration: Hashable {
        var imageState: ImageState = .empty
        var contentMode: ContentMode = .fill
    }
}

// MARK: - Shimmering

extension TLImageView.Configuration {

    var isShimmering: Bool {
        imageState == .loading
    }
}
