//
//  FeedbackProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol FeedbackDisplayLogic: FeedbackViewModelInput {
    var uiProperties: FeedbackModel.UIProperties { get set }
}

protocol FeedbackViewModelInput {
}

protocol FeedbackViewModelOutput {
    func didTapSendFeedbackButton()
    func didTapStar(count: Int)
}
