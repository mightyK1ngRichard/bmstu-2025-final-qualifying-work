//
//  ProfileProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 03.01.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

protocol ProfileDisplayLogic: ProfileViewModelInput {
    var uiProperties: ProfileModel.UIProperties { get set }
    var user: UserModel { get }
    var isCurrentUser: Bool { get }
}

protocol ProfileViewModelInput {
    func setEnvironmentObjects(coordinator: Coordinator)
    func configureAvatarImage() -> TLImageView.Configuration
    func configureHeaderImage() -> TLImageView.Configuration
    func configureProductCard(for cake: CakeModel) -> TLProductCard.Configuration
}

protocol ProfileViewModelOutput {
    func didTapCreateProduct()
    func didTapOpenSettings()
    func didTapOpenMap()
    func didTapWriteMessage()
    func didTapCakeLikeButton(cake: CakeModel, isSelected: Bool)
    func didTapCakeCard(with cake: CakeModel)
}
