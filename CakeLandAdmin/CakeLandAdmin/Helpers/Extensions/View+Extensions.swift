//
//  View+Extensions.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import SwiftUI
import MacCore

extension View {

    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }

    var asView: AnyView {
        AnyView(self)
    }

}

extension View {

    func defaultAlert(
        errorContent: ErrorContent,
        isPresented: Binding<Bool>,
        action: TLVoidBlock? = nil
    ) -> some View {
        alert(
            errorContent.title,
            isPresented: isPresented
        ) {
            Button("OK") {
                action?()
            }
        } message: {
            Text(errorContent.message)
        }
    }

}

// MARK: - ViewFirstAppearModifier

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
