//
//  RatingReviewsModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum RatingReviewsModel {}

extension RatingReviewsModel {
    struct UIProperties: Hashable {
        var isOpenFeedbackView = false
        var showFeedbackButton = false
        var state: ScreenState = .initial
    }
}
