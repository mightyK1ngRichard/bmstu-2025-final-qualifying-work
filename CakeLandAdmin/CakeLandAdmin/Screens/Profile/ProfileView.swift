//
//  ProfileView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 15.05.2025.
//

import SwiftUI

@Observable
final class ProfileViewModel {
    private(set) var userModel: UserModel?
    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProviderImpl

    init(networkManager: NetworkManager, imageProvider: ImageLoaderProviderImpl) {
        self.networkManager = networkManager
        self.imageProvider = imageProvider
    }
}

extension ProfileViewModel {

    func fetchUserInfo() {
        Task { @MainActor in
            do {
                let res = try await networkManager.profileService.getUserInfo()
                let profile = res.userInfo.profile
                userModel = UserModel(from: profile)
                fetchUserImages(avatar: profile.imageURL, header: profile.headerImageURL)
            } catch {

            }
        }
    }

    func fetchUserImages(avatar: String?, header: String?) {
        Task { @MainActor in
            guard let avatar else {
                userModel?.avatarImage.imageState = .error("image is nil")
                return
            }

            let imageState = await imageProvider.fetchImage(for: avatar)
            userModel?.avatarImage.imageState = imageState
        }

        Task { @MainActor in
            guard let header else {
                userModel?.headerImage.imageState = .error("image is nil")
                return
            }

            let imageState = await imageProvider.fetchImage(for: header)
            userModel?.headerImage.imageState = imageState
        }
    }

}

struct ProfileView: View {
    @State var viewModel: ProfileViewModel

    var body: some View {
        VStack {
            if let user = viewModel.userModel {
                userInfoView(user: user)
            }
            Spacer()
        }
        .onFirstAppear {
            viewModel.fetchUserInfo()
        }
    }
}

extension ProfileView {

    func userInfoView(user: UserModel) -> some View {
        VStack(alignment: .leading) {
            imageContainer(user: user)
        }
        .padding([.horizontal, .top])
        .background()
        .clipShape(.rect(cornerRadius: 12))
        .padding(.horizontal, 32)
        .padding(.top)
    }

    func imageContainer(user: UserModel) -> some View {
        ZStack(alignment: .topLeading) {
            TLImageView(configuration: .init(imageState: user.headerImage.imageState))
                .frame(height: Constants.avatarImageSize + 250)
                .clipShape(.rect(cornerRadius: 12))

            VStack {
                TLImageView(configuration: .init(imageState: user.avatarImage.imageState))
                    .frame(width: Constants.avatarImageSize, height: Constants.avatarImageSize)
                    .clipShape(.circle)
                    .padding(2)
                    .background(.background, in: .circle)

                textContainer(user: user)
            }
            .padding(.top, 283)
            .padding(.leading, 56)
        }
        .padding(.bottom, 33)
    }

    func textContainer(user: UserModel) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let fio = user.fio {
                Text(fio)
                    .style(30, .semibold)
            }

            Text("@\(user.nickname)")
                .font(.system(size: 13, weight: .regular))
                .italic()
                .foregroundStyle(.secondary)

            Text(user.mail)
                .font(.system(size: 12))
                .foregroundStyle(.tertiary)
        }
        .textSelection(.enabled)
    }

}

// MARK: - Preview

#Preview {
    ProfileAssembler.assemble(
        networkManager: .init(),
        imageProvider: .init()
    )
    .frame(width: 500, height: 500)
}

// MARK: - Constants

private extension ProfileView {

    enum Constants {
        static let avatarImageSize: CGFloat = 180
    }
}
