//
//  ContentView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 10.05.2025.
//

import SwiftUI
import NetworkAPI
import SwiftUI

struct RootView: View {
    @State var viewModel: RootViewModel

    var body: some View {
        contentContainer
            .defaultAlert(
                errorContent: viewModel.bindingData.alert.errorContent,
                isPresented: $viewModel.bindingData.alert.isShown
            )
    }
}

// MARK: - UI Subviews

extension RootView {

    @ViewBuilder
    var contentContainer: some View {
        switch viewModel.bindingData.startScreenKind {
        case .authed:
            contentView
        case .needAuth:
            needAuthView
        }
    }

    var contentView: some View {
        NavigationSplitView {
            sideBarContainer
        } detail: {
            detailContainer
        }
    }

    var sideBarContainer: some View {
        List(AppSection.allCases, id: \.self, selection: $viewModel.bindingData.selectedTab) { section in
            NavigationLink(value: section) {
                Label(
                    title: { Text(section.rawValue) },
                    icon: { Image(systemName: section.iconName) }
                )
            }
        }
        .navigationTitle("Разделы")
    }

    @ViewBuilder
    var detailContainer: some View {
        switch viewModel.bindingData.selectedTab {
        case .home:
            Text("Детали: Главная")
        case .orders:
            viewModel.assembleOrderListViwe()
        case .profile:
            Text("Детали: Профиль")
        case .settings:
            Text("Детали: Настройки")
        }
    }

    var needAuthView: some View {
        VStack(spacing: 16) {
            Text("Login")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $viewModel.bindingData.inputEmail)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
            
            SecureField("Password", text: $viewModel.bindingData.inputPassword)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)

            Button(action: {
                viewModel.didTapSignIn()
            }) {
                if viewModel.bindingData.signInButtonIsLoading {
                    ProgressView()
                        .controlSize(.small)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(viewModel.bindingData.signInButtonIsDisabled)
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
            .frame(width: 300)
            .keyboardShortcut(.defaultAction)
        }
        .padding()
    }

}

// MARK: - Preview

#Preview {
    RootAssembler.assemble()
}
