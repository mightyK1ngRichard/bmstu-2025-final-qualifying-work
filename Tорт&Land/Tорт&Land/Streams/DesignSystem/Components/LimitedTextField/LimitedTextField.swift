//
//  LimitedTextField.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 06.04.2024.
//

import SwiftUI

struct LimitedTextField: View {
    var configuration: Configuration
    var hint: String
    @Binding var value: String
    @FocusState private var isKeyboardShowing: Bool
    var onSubmit: TLVoidBlock?

    var body: some View {
        VStack(alignment: configuration.progressConfig.alignment, spacing: 12) {
            ZStack(alignment: .top) {
                TappedView

                TextFieldView
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: configuration.borderConfig.radius)
                    .stroke(progressColor.gradient, lineWidth: configuration.borderConfig.width)
            }

            ProgressBar
        }
    }

    // MARK: Calculated Values

    private var progress: CGFloat {
        max(min(CGFloat(value.count) / CGFloat(configuration.limit), 1), 0)
    }

    private var progressColor: Color {
        progress < 0.6 ? configuration.tint : progress == 1 ? .red : .orange
    }
}

// MARK: - Private UI Subviews

private extension LimitedTextField {

    var TappedView: some View {
        RoundedRectangle(cornerRadius: configuration.borderConfig.radius)
            .fill(.clear)
            .frame(height: configuration.autoResizes ? 0 : nil)
            .contentShape(.rect(cornerRadius: configuration.borderConfig.radius))
            .onTapGesture {
                isKeyboardShowing = true
            }
    }

    var TextFieldView: some View {
        TextField(hint, text: $value, axis: .vertical)
            .focused($isKeyboardShowing)
            .onChange(of: value, initial: true) { oldValue, newValue in
                guard !configuration.allowsExcessTyping else { return }
                value = String(value.prefix(configuration.limit))
            }
            .onSubmit {
                onSubmit?()
            }
            .submitLabel(configuration.submitLabel)
    }

    var ProgressBar: some View {
        HStack(alignment: .top, spacing: 12) {
            if configuration.progressConfig.showsRing {
                ZStack {
                    Circle()
                        .stroke(.ultraThinMaterial, lineWidth: 5)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(progressColor.gradient, lineWidth: 5)
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 20, height: 20)
            }

            if configuration.progressConfig.showsText {
                Text("\(value.count)/\(configuration.limit)")
                    .foregroundStyle(progressColor.gradient)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LimitedTextField(
        configuration: .init(limit: 40, tint: .secondary, autoResizes: true),
        hint: "Type here",
        value: .constant("")
    )
    .frame(maxHeight: 150)
    .padding()
}
