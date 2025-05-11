//
//  TLCustomTabBarView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 08.03.2024.
//

import SwiftUI
import DesignSystem

struct TLCustomTabBarView: View {
    @State private var allTabs: [AnimatedTab] = TabBarItem.allCases.compactMap {
        AnimatedTab(tabBarItem: $0)
    }
    @State private var tabBarColor = TLColor<BackgroundPalette>.bgMainColor.color
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        customTabBar
            .shadow(color: TLColor<ShadowPalette>.tabBarShadow.color, radius: 10)
    }
}

// MARK: - Private Subviews

private extension TLCustomTabBarView {
    @ViewBuilder
    var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tabBarItem = animatedTab.tabBarItem
                VStack(spacing: 4) {
                    Image(systemName: tabBarItem.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.down.byLayer, value: animatedTab.isAnimating)

                    Text(tabBarItem.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(
                    coordinator.activeTab == tabBarItem
                        ? Constants.iconSelectedColor
                        : Constants.iconUnselectedColor
                )
                .padding(.vertical, 5)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete) {
                        tabBarColor = Constants.defaultBgColor
                        coordinator.activeTab = tabBarItem
                        animatedTab.isAnimating = true
                    } completion: {
                        var trasnaction = Transaction()
                        trasnaction.disablesAnimations = true
                        withTransaction(trasnaction) {
                            animatedTab.isAnimating = nil
                        }
                    }

                }
            }
        }
        .background(tabBarColor)
    }
}

// MARK: - Preview

#Preview {
    TLCustomTabBarView()
        .environment(Coordinator())
}

// MARK: - Constants

private extension View {
    @ViewBuilder
    func setUpTab(_ TabBarItem: TabBarItem) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(TabBarItem)
            .toolbar(.hidden, for: .tabBar)
    }
}

private extension TLCustomTabBarView {
    enum Constants {
        static let iconSelectedColor = TLColor<IconPalette>.iconRed.color
        static let iconUnselectedColor = TLColor<IconPalette>.iconGray.color
        static let defaultBgColor = TLColor<BackgroundPalette>.bgMainColor.color
    }
}
