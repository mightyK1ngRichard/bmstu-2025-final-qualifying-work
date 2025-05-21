//
//  TLChatCell+Defaults.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation
import Core

public extension TLChatCell.Configuration {

    /// Basic configuration
    /// - Parameters:
    ///   - imageState: image state
    ///   - title: user name
    ///   - subtitle: last chat message
    ///   - time: time of last chat message
    /// - Returns: configuration of the view
    static func basic(
        imageState: ImageState,
        title: String,
        subtitle: String,
        time: String?
    ) -> TLChatCell.Configuration {
        .init(
            imageConfiguration: .init(imageState: imageState),
            title: title,
            subtitle: subtitle,
            time: time
        )
    }

    static var shimmering: Self {
        .init(
            imageConfiguration: .init(imageState: .loading),
            isShimmering: true
        )
    }
}
