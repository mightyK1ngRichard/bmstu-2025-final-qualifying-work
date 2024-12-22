//
//  ShimmeringView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

struct ShimmeringView: View {
    @State private var isAnimating = false
    @State private var startPoint = UnitPoint(x: -1.8, y: -1.2)
    @State private var endPoint = UnitPoint(x: 0, y: -0.2)

    var body: some View {
        LinearGradient(
            colors: Constants.colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: false)
            ) {
                startPoint = .init(x: 1, y: 1)
                endPoint = .init(x: 2.5, y: 2.2)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ShimmeringView()
}

// MARK: - Constants

private extension ShimmeringView {
    enum Constants {
        static let shimmeringColor = TLColor<BackgroundPalette>.bgShimmering.color
        static let colors = [
            shimmeringColor,
            Color(uiColor: UIColor.systemGray5),
            shimmeringColor
        ]
    }
}
