//
//  TLChatCell+Configuration.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 08.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import UIKit

public extension TLChatCell {

    struct Configuration: Hashable {
        /// Configuration of the image view
        var imageConfiguration: TLImageView.Configuration = .init()

        // MARK: Properties

        /// Title text
        var title = ""
        /// Subtitle text
        var subtitle = ""
        /// Time text
        var time: String?
        /// Shimmering flag
        var isShimmering = false
    }

}
