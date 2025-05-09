//
//  FeedbackView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import DesignSystem

extension FeedbackView {

    var mainContainer: some View {
        VStack(spacing: 0) {
            starsContainer
            titleView
            textInputView
            sendFeedbackButtonView
        }
        .background(Constants.bgColor)
        .overlay {
            loadingView
        }
        .defaultAlert(
            errorContent: viewModel.uiProperties.alert.errorContent,
            isPresented: $viewModel.uiProperties.alert.isShown,
            action: viewModel.didTapCloseErrorAlert
        )
    }

    @ViewBuilder
    var loadingView: some View {
        if viewModel.uiProperties.isLoading {
            ProgressView()
        }
    }

    var starsContainer: some View {
        VStack {
            Text(Constants.ratingTitle)
                .style(18, .semibold, Constants.titleColor)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { index in
                    Image(
                        index > viewModel.uiProperties.countFillStars
                            ? .starOutline
                            : .starFill
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
                    .padding(5)
                    .contentShape(.rect)
                    .onTapGesture {
                        viewModel.didTapStar(count: index)
                    }
                }
            }
        }
    }

    var titleView: some View {
        Text(Constants.title)
            .style(18, .semibold, Constants.titleColor)
            .padding(.horizontal, 70)
            .multilineTextAlignment(.center)
            .padding(.top, 32)
    }

    var textInputView: some View {
        LimitedTextField(
            configuration: .init(
                limit: 550,
                tint: Constants.titleColor,
                autoResizes: false,
                allowsExcessTyping: false,
                submitLabel: .return,
                progressConfig: .init(
                    showsRing: true,
                    showsText: true,
                    alignment: .trailing
                ),
                borderConfig: .init(
                    show: true,
                    radius: 6,
                    width: 1
                )
            ),
            hint: Constants.feedbackPlaceholder,
            value: $viewModel.uiProperties.feedbackText
        )
        .padding(.horizontal)
        .padding(.top, 18)
    }

    var sendFeedbackButtonView: some View {
        Button(action: viewModel.didTapSendFeedbackButton, label: {
            Text(Constants.sendFeedbackTitle.uppercased())
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity)
        })
        .padding(.vertical, 14)
        .background(Constants.sendFeedbackButtonColor, in: .rect(cornerRadius: 25))
        .padding(.horizontal)
        .tint(Color.white)
        .padding(.bottom, 6)
        .padding(.top, 18)
        .disabled(viewModel.uiProperties.isLoading)
    }
}

// MARK: - Preview

#Preview {
    FeedbackView(viewModel: FeedbackViewModelMock())
}

// MARK: - Constants

private extension FeedbackView {

    enum Constants {
        static let ratingTitle = String(localized: "What is you rate?")
        static let title = String(localized: "Please share your opinion about the product")
        static let feedbackPlaceholder = String(localized: "Your feedback")
        static let sendFeedbackTitle = String(localized: "Send review")
        static let titleColor = TLColor<TextPalette>.textPrimary.color
        static let bgColor = TLColor<BackgroundPalette>.bgMainColor.color
        static let sendFeedbackButtonColor = TLColor<BackgroundPalette>.bgRed.color
    }
}
