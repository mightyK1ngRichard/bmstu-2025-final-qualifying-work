//
//  View+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
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

// MARK: Helper

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
