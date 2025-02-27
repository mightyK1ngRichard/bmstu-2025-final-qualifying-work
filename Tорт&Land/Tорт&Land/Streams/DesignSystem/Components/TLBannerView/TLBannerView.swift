//
//  TLBannerView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

/**
 Component `TLBannerView`

 For example:
 ```swift
 let view = TLBannerView(
     configuration: .basic(
         title: "Торт&\nLand",
         buttonTitle: "Check"
     )
 )
 ```
*/
struct TLBannerView: View, Configurable {
    let configuration: Configuration
    var didTapButton: TLVoidBlock?

    var body: some View {
        TLImageView(configuration: configuration.imageConfiguration)
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 18) {
                    Text(configuration.bannerTitle)
                        .font(.system(size: 48, weight: .black))
                        .foregroundStyle(.white)

                    if let title = configuration.buttonTitle {
                        Button {
                            didTapButton?()
                        } label: {
                            Text(title)
                                .style(14, .medium, .white)
                                .frame(width: 160, height: 36)
                                .background(TLColor<BackgroundPalette>.bgBasketColor.color)
                                .clipShape(.rect(cornerRadius: 25))
                        }
                    }
                }
                .padding(.leading, 15)
                .padding(.bottom, 32)
            }
    }
}

// MARK: - Preview

#Preview {
    TLBannerView(
        configuration: .basic(
            title: "Торт&\nLand",
            buttonTitle: "Check"
        )
    )
    .frame(height: 536)
}
