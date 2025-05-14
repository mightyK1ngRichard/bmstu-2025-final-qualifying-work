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
                errorContent: viewModel.bindingData.alert.content,
                isPresented: $viewModel.bindingData.alert.isShown
            )
    }
}

// MARK: - UI Subviews

private extension RootView {

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
            logoutButton
        } detail: {
            detailContainer
        }
    }

    var sideBarContainer: some View {
        List(AppSection.allCases, id: \.self,
             selection: $viewModel.bindingData.selectedTab) { section in
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
            viewModel.assembleCategoriesView()
        case .cakes:
            viewModel.assembleCakesList()
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

    var logoutButton: some View {
        Button {
            viewModel.didTapLogout()
        } label: {
            Label("Выйти", systemImage: "rectangle.portrait.and.arrow.right")
        }
        .buttonStyle(.plain)
        .padding(.bottom)
    }

}

// MARK: - Preview

#Preview {
    RootAssembler.assemble()
}
