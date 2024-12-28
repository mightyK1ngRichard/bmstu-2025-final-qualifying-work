//
//  TLCategoryCell.swift
//  CHMUIKIT
//
//  Created by Dmitriy Permyakov on 27.01.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

/**
 Component `TLCategoryCell`

 For example:
 ```swift
 let view = TLCategoryCell(
     configuration: .constant(
         .basic(
             imageState: .fetched(.uiImage(.cake2)),
             title: "Clothes"
         )
     )
 )
 ```
*/
struct TLCategoryCell: View {
    let configuration: Configuration

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            HStack {
                Text(configuration.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(TLColor<TextPalette>.textPrimary.color)
                    .padding(.leading, 23)
                Spacer()
                TLImageView(configuration: configuration.imageConfiguration)
                    .frame(width: size.width / 2, height: size.height)
            }
        }
        .frame(height: 100)
        .background(TLColor<BackgroundPalette>.bgCommentView.color)
        .clipShape(.rect(cornerRadius: 8))
    }
}

// MARK: - Preview

#Preview {
    TLCategoryCell(
        configuration: .basic(
            imageState: .fetched(.uiImage(.cake2)),
            title: "Clothes"
        )
    )
    .padding()
    .background(TLColor<PreviewPalette>.bgPreview.color)
}
