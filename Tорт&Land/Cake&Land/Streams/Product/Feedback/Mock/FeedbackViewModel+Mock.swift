//
//  FeedbackViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

#if DEBUG
import Foundation

@Observable
final class FeedbackViewModelMock: FeedbackDisplayLogic, FeedbackViewModelInput {
    var uiProperties = FeedbackModel.UIProperties()

    func didTapSendFeedbackButton() {
        print("[DEBUG]: \(#function)")
    }

    func didTapStar(count: Int) {
        print("[DEBUG]: count=\(count)")
        uiProperties.countFillStars = count
    }

    func didTapCloseErrorAlert() {
        print("[DEBUG]: \(#function)")
    }
}
#endif
