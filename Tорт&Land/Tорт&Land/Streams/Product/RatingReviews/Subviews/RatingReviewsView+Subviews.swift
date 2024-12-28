//
//  RatingReviewsView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension RatingReviewsView {

    var mainContainer: some View {
        ScrollView {
            ratingBlock
            sectionTitle
            reviewsBlock
        }
        .background(TLColor<BackgroundPalette>.bgMainColor.color)
        .navigationTitle(Constants.navigationTitle)
        .overlay(alignment: .bottomTrailing) {
            writeReviewButton
        }
        .blurredSheet(
            .init(TLColor<BackgroundPalette>.bgMainColor.color),
            show: $viewModel.uiProperties.isOpenFeedbackView
        ) {} content: {
            sheetView
                .padding(.top)
                .presentationDetents([.medium, .large])
        }
    }

    var ratingBlock: some View {
        TLRatingReviewsView(
            configuration: viewModel.configureReviewConfiguration()
        )
        .padding(.horizontal)
        .padding(.top, 37)
    }

    var sectionTitle: some View {
        Text(Constants.sectionTitle(count: viewModel.comments.count).capitalized)
            .style(24, .semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.init(top: 37, leading: 16, bottom: 30, trailing: 32))
    }

    var reviewsBlock: some View {
        LazyVStack {
            ForEach(viewModel.comments) { comment in
                TLCommentView(
                    configuration: viewModel.configureCommentConfiguration(comment: comment)
                )
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 32)
    }

    var writeReviewButton: some View {
        Button(action: viewModel.didTapWriteReviewButton, label: {
            HStack(spacing: 9) {
                Image(.pen)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 13, height: 13)

                Text(Constants.writeReviewButtonTitle)
                    .style(11, .semibold, .white)
            }
        })
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(TLColor<BackgroundPalette>.bgRed.color, in: .rect(cornerRadius: 25))
        .padding(.trailing, 26)
    }

    var sheetView: some View {
        viewModel.openSheetView()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        RatingReviewsView(viewModel: RatingReviewsViewModelMock())
    }
    .environment(Coordinator())
}

// MARK: - Constants

private extension RatingReviewsView {

    enum Constants {
        static let navigationTitle = String(localized: "Rating&Reviews")
        static func sectionTitle(count: Int) -> String { String(localized: "reviews") + ": \(count)" }
        static let writeReviewButtonTitle = String(localized: "Write a review")
    }
}
