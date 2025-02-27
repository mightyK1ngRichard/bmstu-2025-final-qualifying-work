//
//  CHMNewCategoryView+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

extension TLCategoryCell.Configuration {

    /// Basic configuration
    /// - Parameters:
    ///   - imageState: image state
    ///   - title: title of the category view
    /// - Returns: configuration of the view
    static func basic(
        imageState: ImageState,
        title: String
    ) -> Self {
        .init(
            imageConfiguration: .init(imageState: imageState),
            title: title
        )
    }
}
