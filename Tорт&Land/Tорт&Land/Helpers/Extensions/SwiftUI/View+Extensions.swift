//
//  View+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }

    var asView: AnyView {
        AnyView(self)
    }
}

private struct ViewFirstAppearModifier: ViewModifier {
    @State private var didAppearBefore = false
    private let action: () -> Void

    init(perform action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppearBefore else { return }
            didAppearBefore = true
            action()
        }
    }
}

// MARK: - Sheet View

extension View {
    func blurredSheet<Content: View>(
        _ style: AnyShapeStyle,
        show: Binding<Bool>,
        onDismiss: @escaping TLVoidBlock,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        sheet(isPresented: show, onDismiss: onDismiss) {
            content()
                .background(RemovebackgroundColor())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Rectangle()
                        .fill(style)
                        .ignoresSafeArea(.container, edges: .all)
                )
        }
    }
}

struct RemovebackgroundColor: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}

// MARK: - Scroll view

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader {
                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX

                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: completion)
            }
        }
    }

    func tabMask(_ progress: CGFloat, count: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(TLColor<TextPalette>.textSecondary.color)

            self
                .foregroundStyle(TLColor<TextPalette>.textPrimary.color)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capsuleWidth = size.width / count
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: progress * (size.width - capsuleWidth))
                    }
                }
        }
    }
}

// MARK: - Alert

extension View {
    func defaultAlert(
        title: String,
        message: String,
        isPresented: Binding<Bool>,
        action: TLVoidBlock? = nil
    ) -> some View {
        alert(
            title,
            isPresented: isPresented
        ) {
            Button("OK") {
                action?()
            }
        } message: {
            Text(message)
        }
    }
}
