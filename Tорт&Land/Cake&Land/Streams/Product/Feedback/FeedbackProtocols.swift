//
//  FeedbackProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol FeedbackDisplayLogic {
    var uiProperties: FeedbackModel.UIProperties { get set }
}

protocol FeedbackViewModelInput {
    func didTapSendFeedbackButton()
    func didTapStar(count: Int)
    func didTapCloseErrorAlert()
}
