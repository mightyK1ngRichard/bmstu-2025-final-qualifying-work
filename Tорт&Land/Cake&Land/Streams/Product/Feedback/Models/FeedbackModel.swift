//
//  FeedbackModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

enum FeedbackModel {
    struct UIProperties: Hashable {
        var countFillStars = 0
        var feedbackText = ""
        var isLoading = false
        var alert = AlertModel()
    }
}
