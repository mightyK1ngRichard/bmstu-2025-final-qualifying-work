//
//  FeedbackViewModel+Mock.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//

#if DEBUG
import Foundation

@Observable
final class FeedbackViewModelMock: FeedbackDisplayLogic, FeedbackViewModelOutput {
    var uiProperties = FeedbackModel.UIProperties()

    func didTapSendFeedbackButton() {
        print("[DEBUG]: \(#function)")
    }

    func didTapStar(count: Int) {
        print("[DEBUG]: count=\(count)")
        uiProperties.countFillStars = count
    }
}
#endif
