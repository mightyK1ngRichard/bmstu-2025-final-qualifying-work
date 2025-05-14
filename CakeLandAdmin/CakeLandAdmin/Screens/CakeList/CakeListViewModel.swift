//
//  CakeListViewModel.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 14.05.2025.
//

import Foundation
import Observation
import AppKit
import Combine

// MARK: - BindingData

extension CakeListViewModel {
    struct BindingData: Hashable {
        var screenState: ScreenState = .initial
        var selectedStatus: CakeStatus = .unspecified
        var showSaveButtonLoading = false
        var alert = AlertModel()
    }
}

// MARK: - CakeListViewModel

extension CakeListViewModel {
    var filteredCakeIndices: [Int] {
        guard bindingData.selectedStatus != .unspecified else {
            return cakes.indices.map { $0 }
        }

        return cakes.indices.filter { cakes[$0].status == bindingData.selectedStatus }
    }

    var cakeStatusDistribution: [CakeStatus: Int] {
        var result = Dictionary(uniqueKeysWithValues: CakeStatus.allCases.map { ($0, 0) })
        for cake in cakes {
            result[cake.status, default: 0] += 1
        }
        return result
    }
}

@Observable
final class CakeListViewModel {
    var bindingData = BindingData()
    var cakes: [CakeModel] = []
    let cakeChangeSubject = PassthroughSubject<CakeModel, Never>()
    private(set) var changedCakes: Set<CakeModel> = []

    @ObservationIgnored
    private let networkManager: NetworkManager
    @ObservationIgnored
    private let imageProvider: ImageLoaderProviderImpl
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()

    init(networkManager: NetworkManager, imageProvider: ImageLoaderProviderImpl) {
        self.networkManager = networkManager
        self.imageProvider = imageProvider
        subscribeToCakeChanges()
    }

    private func subscribeToCakeChanges() {
        cakeChangeSubject
            .sink { [weak self] updatedCake in
                self?.changedCakes.insert(updatedCake)
            }
            .store(in: &cancellables)
    }
}

extension CakeListViewModel {

    func fetchCakes() {
        bindingData.screenState = .loading
        Task { @MainActor in
            let entities = try await networkManager.cakeService.fetchAllCakesWithAllStatuses()
            cakes = entities.map(CakeModel.init(from:))
            for (index, entity) in entities.enumerated() {
                fetchCakeImage(for: entity.imageURL, with: index)
            }
            bindingData.screenState  = .finished
        }
    }

    func fetchCakeImage(for imageURL: String, with index: Int) {
        Task { @MainActor in
            let imageState = await imageProvider.fetchImage(for: imageURL)
            cakes[index].previewImage.imageState = imageState
        }
    }

    func saveChanges() {
        bindingData.showSaveButtonLoading = true
        Task { @MainActor in
            do {
                try await withThrowingTaskGroup(of: Void.self) { group in
                    for cake in changedCakes {
                        group.addTask {
                            try await self.networkManager.cakeService.updateCakeVisibility(
                                cakeID: cake.id,
                                status: cake.status.toProto
                            )
                        }
                    }

                    // Ждём завершения всех задач
                    try await group.waitForAll()
                    changedCakes.removeAll()
                    showSuccessAlert()
                }
            } catch {
                bindingData.alert = AlertModel(content: error.readableGRPCContent, isShown: true)
            }
            bindingData.showSaveButtonLoading = false
        }
    }

    private func showSuccessAlert() {
        let alert = NSAlert()
        alert.messageText = "Успешно"
        alert.informativeText = "Статусы тортов обновлены"
        alert.alertStyle = .informational

        if let image = NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil) {
            alert.icon = image
        }

        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

}
