//
//  TLImageView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI
import MacCore

public extension TLImageView {

    struct Configuration: Hashable {
        var imageState: ImageState = .loading
        var contentMode: ContentMode = .fill

        public init(
            imageState: ImageState = .loading,
            contentMode: ContentMode = .fill
        ) {
            self.imageState = imageState
            self.contentMode = contentMode
        }
    }

}

// MARK: - Shimmering

public extension TLImageView.Configuration {
    var isShimmering: Bool {
        imageState == .loading
    }
}
