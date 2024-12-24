//
//  LimitedTextField.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.04.2024.
//

import SwiftUI

struct LimitedTextField: View {
    var config: Config
    var hint: String
    @Binding var value: String
    @FocusState private var isKeyboardShowing: Bool
    var onSubmit: TLVoidBlock?

    var body: some View {
        VStack(alignment: config.progressConfig.alignment, spacing: 12) {
            ZStack(alignment: .top) {
                TappedView

                TextFieldView
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: config.borderConfig.radius)
                    .stroke(progressColor.gradient, lineWidth: config.borderConfig.width)
            }

            ProgressBar
        }
    }

    // MARK: Calculated Values

    private var progress: CGFloat {
        max(min(CGFloat(value.count) / CGFloat(config.limit), 1), 0)
    }

    private var progressColor: Color {
        progress < 0.6 ? config.tint : progress == 1 ? .red : .orange
    }
}

// MARK: - Private UI Subviews

private extension LimitedTextField {

    var TappedView: some View {
        RoundedRectangle(cornerRadius: config.borderConfig.radius)
            .fill(.clear)
            .frame(height: config.autoResizes ? 0 : nil)
            .contentShape(.rect(cornerRadius: config.borderConfig.radius))
            .onTapGesture {
                isKeyboardShowing = true
            }
    }

    var TextFieldView: some View {
        TextField(hint, text: $value, axis: .vertical)
            .focused($isKeyboardShowing)
            .onChange(of: value, initial: true) { oldValue, newValue in
                guard !config.allowsExcessTyping else { return }
                value = String(value.prefix(config.limit))
            }
            .onSubmit {
                onSubmit?()
            }
            .submitLabel(config.submitLabel)
    }

    var ProgressBar: some View {
        HStack(alignment: .top, spacing: 12) {
            if config.progressConfig.showsRing {
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

            if config.progressConfig.showsText {
                Text("\(value.count)/\(config.limit)")
                    .foregroundStyle(progressColor.gradient)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LimitedTextField(
        config: .init(limit: 40, tint: .secondary, autoResizes: true),
        hint: "Type here",
        value: .constant("")
    )
    .frame(maxHeight: 150)
    .padding()
}

#Preview {
    LimitedTextFieldPreview()
}
