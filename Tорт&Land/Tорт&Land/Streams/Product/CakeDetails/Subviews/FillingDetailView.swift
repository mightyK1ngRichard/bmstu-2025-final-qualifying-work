//
//  FillingDetailView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension FillingDetailView {
    struct Configuration: Hashable {
        /// Название начинки
        var name: String
        /// Состояние изображения начинки
        var imageState: ImageState
        /// Состав начинки
        var content: String
        /// Цена за кг
        var kgPrice: String
        /// Описание начинки
        var description: String
    }
}

struct FillingDetailView: View, Configurable {
    let configuration: Configuration

    var body: some View {
        VStack(alignment: .leading) {
            imageView
            VStack(alignment: .leading, spacing: 16) {
                headerView
                descriptionView
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - UI Subviews

private extension FillingDetailView {
    var imageView: some View {
        TLImageView(
            configuration: .init(imageState: configuration.imageState)
        )
        .frame(height: 180)
    }

    var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(configuration.name)
                    .style(18, .semibold, TLColor<TextPalette>.textPrimary.color)

                Text(configuration.content)
                    .style(14, .regular, TLColor<TextPalette>.textWild.color)
            }
            Spacer()
            Text(configuration.kgPrice)
                .style(24, .semibold)
        }
    }

    var descriptionView: some View {
        Text(configuration.description)
            .style(14, .regular, TLColor<TextPalette>.textSecondary.color)
            .lineSpacing(6)
    }
}

// MARK: - Preview

#Preview {
    FillingDetailView(
        configuration: .init(
            name: "Клубничная начинка Клуб начинка",
            imageState: .fetched(.uiImage(.filling2)),
            content: "Клубника, сливки, масло",
            kgPrice: "100 руб/кг",
            description: """
            Это просто какое-то длинное описание этого товара  Это просто какое-то длинное описание этого товара Это просто какое-то длинное описание этого товара
            """
        )
    )
}
