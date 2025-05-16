//
//  ShimmeringView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI

public struct ShimmeringView: View {
    var kind: ShimmeringKind = .default
    @State private var isAnimating = false
    @State private var startPoint = UnitPoint(x: -1.8, y: -1.2)
    @State private var endPoint = UnitPoint(x: 0, y: -0.2)

    public init(kind: ShimmeringKind = .default) {
        self.kind = kind
    }

    public var body: some View {
        LinearGradient(
            colors: kind.colors,
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

// MARK: - ShimmeringKind

public extension ShimmeringView {
    enum ShimmeringKind: Hashable {
        case `default`
        case inverted
    }
}

private extension ShimmeringView.ShimmeringKind {
    var colors: [Color] {
        switch self {
        case .default:
            return [
                Constants.shimmering2,
                Constants.shimmering1,
                Constants.shimmering2,
            ]
        case .inverted:
            return [
                Constants.shimmering1,
                Constants.shimmering2,
                Constants.shimmering1,
            ]
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        ShimmeringView()
            .frame(height: 100)

        ShimmeringView(kind: .inverted)
            .frame(height: 100)
    }
}

// MARK: - Constants

private extension ShimmeringView.ShimmeringKind {
    enum Constants {
        static let shimmering1 = Color.bgMain
        static let shimmering2 = Color.bgComment
    }
}
