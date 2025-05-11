//
//  TLBannerView+Configuration.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import Foundation

public extension TLBannerView {

    struct Configuration: Hashable {
        /// Конфигурация фотографии
        var imageConfiguration: TLImageView.Configuration = .init()
        /// Текст заголовка
        var bannerTitle = ""
        /// Текст кнопки
        var buttonTitle: String?
    }
}
