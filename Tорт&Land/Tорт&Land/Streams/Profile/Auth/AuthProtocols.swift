//
//  AuthProtocols.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//

import Foundation

protocol AuthDisplayLogic: AuthViewModelInput {
    var uiProperties: AuthModel.UIProperties { get set }
}

protocol AuthViewModelInput {
    func setStartScreenControl(_ startScreenControl: StartScreenControl)
}

protocol AuthViewModelOutput {
    func didTapNextButton()
    func didTapToggleAuthMode()
}
