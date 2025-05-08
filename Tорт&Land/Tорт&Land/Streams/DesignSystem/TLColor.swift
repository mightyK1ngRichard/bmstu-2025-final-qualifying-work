//
//  TLColor.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

final class TLColor<Palette: Hashable> {
    let color: Color
    let uiColor: UIColor

    init(hexLight: Int, hexDark: Int, alphaLight: CGFloat = 1.0, alphaDark: CGFloat = 1.0) {
        let lightColor = UIColor(hex: hexLight, alpha: alphaLight)
        let darkColor = UIColor(hex: hexDark, alpha: alphaDark)
        let uiColor = UIColor { $0.userInterfaceStyle == .light ? lightColor : darkColor }
        self.uiColor = uiColor
        self.color = Color(uiColor: uiColor)
    }

    init(hexLight: Int, hexDark: Int, alpha: CGFloat = 1.0) {
        let chmColor = TLColor(hexLight: hexLight, hexDark: hexDark, alphaLight: alpha, alphaDark: alpha)
        self.uiColor = chmColor.uiColor
        self.color = chmColor.color
    }

    init(uiColor: UIColor) {
        self.uiColor = uiColor
        self.color = Color(uiColor: uiColor)
    }
}

// MARK: - Palettes

enum BackgroundPalette: Hashable {}
enum IconPalette: Hashable {}
enum SeparatorPalette: Hashable {}
enum TextPalette: Hashable {}
enum ShadowPalette: Hashable {}
enum CustomPalette: Hashable {}

// MARK: - Background Colors

extension TLColor where Palette == BackgroundPalette {

    /// Красный задний фон. Ex: Кнопка покупки
    static let bgRed = TLColor(hexLight: 0xDB3022, hexDark: 0xEF3651)
    /// Тёмный задний фон. Ex: Бейдж новых продктов
    static let bgDark = TLColor(hexLight: 0x222222, hexDark: 0x1E1F28)
    /// Задний фон икноки корзины, кнопки баннера
    static let bgBasketColor = TLColor(hexLight: 0xDB3022, hexDark: 0xEF3651)
    /// Задний фон иконки лайка
    static let bgFavoriteIcon = TLColor(hexLight: 0xFFFFFF, hexDark: 0x2A2C36)
    /// White gray
    static let bgCommentView = TLColor(hexLight: 0xFFFFFF, hexDark: 0x2A2C36)
    /// App bg color
    static let bgMainColor = TLColor(hexLight: 0xF9F9F9, hexDark: 0x1E1F28)
    /// Search bg color
    static let bgSearchBar = TLColor(hexLight: 0xFFFFFF, hexDark: 0x2A2C36)
    /// Цвет шиммера
    static let bgShimmering = TLColor(hexLight: 0xF3F3F7, hexDark: 0x242429)
    /// Черный белый фон
    static let bgPrimary = TLColor(hexLight: 0xF9F9F9, hexDark: 0x060606)
    /// Белый черный фон
    static let bgInvertedPrimary = TLColor(hexLight: 0x060606, hexDark: 0xF9F9F9)
    /// Фон для text field
    static let bgTextField = TLColor(hexLight: 0xFFFFFF, hexDark: 0x2A2C36)
}

// MARK: - Text Colors

extension TLColor where Palette == TextPalette {

    /// Основной текст
    static let textPrimary = TLColor(hexLight: 0x222222, hexDark: 0xF6F6F6)
    /// Второстепенный текст
    static let textSecondary = TLColor(hexLight: 0x9B9B9B, hexDark: 0xABB4BD)
    /// Текст описания
    static let textDescription = TLColor(hexLight: 0x222222, hexDark: 0xF5F5F5)
    /// Выделенный красный текст: Ex: Цена при скидке
    static let textWild = TLColor(hexLight: 0xDB3022, hexDark: 0xFF3E3E)
    /// Красный текст
    static let textRed = TLColor(hexLight: 0xDB3022, hexDark: 0xEF3651)
    /// Зелёный текст
    static let textSuccess = TLColor(hexLight: 0x2AA952, hexDark: 0x55D85A)
}

// MARK: - Icon Colors

extension TLColor where Palette == IconPalette {

    static let iconRed = TLColor(hexLight: 0xDB3022, hexDark: 0xEF3651)
    static let iconSecondary = TLColor(hexLight: 0x9B9B9B, hexDark: 0x8E8E93)
    static let iconGray = TLColor(hexLight: 0x9B9B9B, hexDark: 0xABB4BD)
    static let iconBasket = TLColor(hexLight: 0xF9F9F9, hexDark: 0xF6F6F6)
    static let iconPrimary = TLColor(hexLight: 0x222222, hexDark: 0xF9F9F9)
    static let iconDarkWhite = TLColor(hexLight: 0x222222, hexDark: 0xF6F6F6)
}

// MARK: - Separator Colors

extension TLColor where Palette == SeparatorPalette {

    /// Красная граница
    static let selectedBorder = TLColor(hexLight: 0xF01F0E, hexDark: 0xFF2424)
    /// Серая граница
    static let unselectedBorder = TLColor(hexLight: 0x9B9B9B, hexDark: 0xABB4BD)
    /// Цвет дивайдера. Ex: палочка при всплывающем окне
    static let divider = TLColor(hexLight: 0x9B9B9B, hexDark: 0xABB4BD)
    /// Красная линия. Ex: Экран рейтинга
    static let redLine = TLColor(hexLight: 0xDB3022, hexDark: 0xFF3E3E)
    /// Красный белый
    static let colorCell = TLColor(hexLight: 0xDB3022, hexDark: 0xABB4BD)
}

// MARK: - Shadow Colors

extension TLColor where Palette == ShadowPalette {

    static let basket = TLColor(hexLight: 0xF9F9F9, hexDark: 0xEF3651, alpha: 0.5)
    static let favoriteSeletected = TLColor(hexLight: 0x9B9B9B, hexDark: 0xEF3651, alphaLight: 0.5, alphaDark: 0)
    static let favoriteUnseletected = TLColor(hexLight: 0x9B9B9B, hexDark: 0x2A2C36, alpha: 0.5)
    static let customShadow = TLColor(hexLight: 0x9B9B9B, hexDark: 0x2A2C36, alpha: 0.5)
    static let tabBarShadow = TLColor(hexLight: 0x000000, hexDark: 0x1A1B20, alphaLight: 0.06)
}
