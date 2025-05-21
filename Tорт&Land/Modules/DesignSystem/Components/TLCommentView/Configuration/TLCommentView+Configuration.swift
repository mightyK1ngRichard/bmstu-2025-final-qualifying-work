//
//  TLCommentView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//

import UIKit

public extension TLCommentView {
    struct Configuration {
        var userImageConfiguration: TLImageView.Configuration = .init()
        var userName = ""
        var date = ""
        var starsConfiguration: TLStarsView.Configuration = .init()
        var description = ""
    }
}
