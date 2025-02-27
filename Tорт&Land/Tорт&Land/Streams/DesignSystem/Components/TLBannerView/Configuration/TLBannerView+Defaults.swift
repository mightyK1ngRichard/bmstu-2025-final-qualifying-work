//
//  TLBannerView+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation

extension TLBannerView.Configuration {

    static func basic(title: String, buttonTitle: String? = nil) -> Self {
        .init(
            imageConfiguration: .init(imageState: .fetched(.uiImage(.banner))),
            bannerTitle: title,
            buttonTitle: buttonTitle
        )
    }
}
