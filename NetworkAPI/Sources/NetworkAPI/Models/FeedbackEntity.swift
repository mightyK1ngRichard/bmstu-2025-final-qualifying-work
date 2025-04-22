//
//  FeedbackEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 21.04.2025.
//

import Foundation

public struct FeedbackEntity: Sendable, Hashable {
    public let id: String
    public let text: String
    public let dateCreation: Date
    public let rating: Int
    public let cakeID: String
    public let author: ProfileEntity
}

extension FeedbackEntity {
    init(from model: Feedback_Feedback) {
        self = FeedbackEntity(
            id: model.id,
            text: model.text,
            dateCreation: model.dateCreation.date,
            rating: Int(model.rating),
            cakeID: model.cakeID,
            author: ProfileEntity(from: model.author)
        )
    }
}
