//
//  NotificationsListAssembler.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI

final class NotificationsListAssembler {
    static func assemble(
        networkManager: NetworkManager,
        imageProvider: ImageLoaderProvider
    ) -> NotificationsListView {
        let viewModel = NotificationsListViewModel(
            networkManager: networkManager,
            imageProvider: imageProvider
        )
        return NotificationsListView(viewModel: viewModel)
    }
}
