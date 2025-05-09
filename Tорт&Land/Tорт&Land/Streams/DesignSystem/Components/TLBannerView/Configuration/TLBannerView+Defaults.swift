//
//  TLBannerView+Defaults.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation
import Core

extension TLBannerView.Configuration {

    public static func basic(title: String, buttonTitle: String? = nil) -> Self {
        .init(
            imageConfiguration: .init(imageState: .fetched(.uiImage(TLAssets.banner))),
            bannerTitle: title,
            buttonTitle: buttonTitle
        )
    }
}
