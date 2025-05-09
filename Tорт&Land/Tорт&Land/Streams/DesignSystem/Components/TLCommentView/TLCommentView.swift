//
//  TLCommentView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//

import SwiftUI

/**
 Component `TLCommentView`

 For example:
 ```swift
 let view = TLCommentView(
     configuration: .constant(
         .basic(
             imageKind: .url(.url),
             userName: "Helene Moore",
             date: "June 5, 2019",
             description: "Описание",
             starsConfiguration: .basic(kind: .four, feedbackCount: 21)
         )
     )
 )
 ```
*/
public struct TLCommentView: View {
    let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(configuration.userName)
                .userNameFont
            
            starsBlock

            Text(configuration.description)
                .descriptionFont
                .padding(.top, 11)
        }
        .padding(EdgeInsets(top: 23, leading: 24, bottom: 33, trailing: 20))
        .background(TLColor<BackgroundPalette>.bgCommentView.color)
        .clipShape(.rect(cornerRadius: 8))
        .overlay(alignment: .topLeading) {
            TLImageView(configuration: configuration.userImageConfiguration)
                .frame(width: 32, height: 32)
                .clipShape(.circle)
                .offset(x: -16, y: -16)
        }
        .padding([.leading, .top], 16)
    }
}

// MARK: - Subviews

private extension TLCommentView {

    var starsBlock: some View {
        HStack {
            TLStarsView(configuration: configuration.starsConfiguration)

            Spacer()

            Text(configuration.date)
                .dateFont
        }
    }
}

// MARK: - Text

private extension Text {

    var userNameFont: some View {
        font(.system(size: 14, weight: .semibold))
            .foregroundStyle(TLColor<TextPalette>.textPrimary.color)
    }

    var descriptionFont: some View {
        font(.system(size: 14, weight: .regular))
            .foregroundStyle(TLColor<TextPalette>.textDescription.color)
            .lineSpacing(8)
    }

    var dateFont: some View {
        font(.system(size: 11, weight: .regular))
            .foregroundStyle(TLColor<TextPalette>.textSecondary.color)
    }
}

// MARK: - Preview

#Preview {
    TLCommentView(
        configuration: .basic(
            imageState: .fetched(.uiImage(.cake1)),
            userName: "Helene Moore",
            date: "June 5, 2019",
            description: """
            The dress is great! Very classy and comfortable. It fit perfectly! I'm 5'7" and 130 pounds. I am a 34B chest. This dress would be too long for those who are shorter but could be hemmed. I wouldn't recommend it for those big chested as I am smaller chested and it fit me perfectly. The underarms were not too wide and the dress was made well.
            """,
            starsConfiguration: .basic(kind: .four, feedbackCount: 21)
        )
    )
    .padding(.horizontal)
}
