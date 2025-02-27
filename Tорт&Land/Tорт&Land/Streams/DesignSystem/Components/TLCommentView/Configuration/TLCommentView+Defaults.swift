//
//  TLCommentView+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//

import Foundation

extension TLCommentView.Configuration {

    /// Basic configuration
    /// - Parameters:
    ///   - imageState: image state
    ///   - userName: user name
    ///   - date: date info
    ///   - description: comment description
    ///   - starsConfiguration: stars view configuration
    /// - Returns: configuration of the view
    static func basic(
        imageState: ImageState,
        userName: String,
        date: String,
        description: String,
        starsConfiguration: TLStarsView.Configuration
    ) -> Self {
        .init(
            userImageConfiguration: .init(imageState: imageState),
            userName: userName,
            date: date,
            starsConfiguration: starsConfiguration,
            description: description
        )
    }
}
