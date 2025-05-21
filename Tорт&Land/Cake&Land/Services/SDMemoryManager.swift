//
//  SDMemoryManager.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 21.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import NetworkAPI
import SwiftData
import Core

final class SDMemoryManager {
    static let shared = SDMemoryManager()
    private init() {}

    /// Оптимальное сохранение новых и обновление уже существующих тортов и пользователей в памяти устройства.
    /// - Important: Список должен содержать уникальные торты, иначе теряется оптимальность.
    ///
    /// - Parameters:
    ///   - entities: Список уникальных тортов
    ///   - modelContext: Контекст контейнера SwiftData
    /// - Note: Метод выполняется в `@MainActor`, так как `ModelContext` должен использоваться только в главном потоке.
    @MainActor
    func saveOrUpdateCakesInMemory(
        entities: [PreviewCakeEntity],
        with modelContext: ModelContext
    ) async {
        var savedUsers: [String: SDUser] = [:]

        for cakeEntity in entities {
            // Если модель уже есть, обновляем. Иначе добавляем
            let cakeID = cakeEntity.id
            let predicate = #Predicate<SDCake> { $0.cakeID == cakeID }

            let resultSDModel: SDCake
            if let existedModel = try? modelContext.fetchFirst(predicate: predicate) {
                existedModel.update(with: cakeEntity)
                resultSDModel = existedModel
            } else {
                let sdCake = SDCake(from: cakeEntity)
                modelContext.insert(sdCake)
                resultSDModel = sdCake
            }

            // Если пользоваетель уже сохранён, присваиваем его. Если нет, запоминаем или обновляем
            let savedSDUser = savedUsers[cakeEntity.owner.id] ?? {
                let user = saveOrUpdateUserInMemory(userEntity: cakeEntity.owner, using: modelContext)
                savedUsers[cakeEntity.owner.id] = user
                return user
            }()
            resultSDModel.owner = savedSDUser
        }

        do {
            try modelContext.save()
        } catch {
            Logger.log(kind: .error, "ошибка сохранения данных тортов: \(error)")
        }
    }
    
    /// Сохраняем или обновляем всю информацию торта.
    /// - Parameters:
    ///   - cakeEntity: Сетевая модель торта
    ///   - modelContext: Контекст контейнера SwiftData
    /// - Note: Метод выполняется в `@MainActor`, так как `ModelContext` должен использоваться только в главном потоке.
    @MainActor
    func saveOrUpdateCakeInMemory(cakeEntity: CakeEntity, using modelContext: ModelContext) async {
        let cakeID = cakeEntity.id
        let predicate = #Predicate<SDCake> { $0.cakeID == cakeID }
        guard let sdCake = try? modelContext.fetchFirst(predicate: predicate) else {
            return
        }

        // Обновляем данные торта
        sdCake.update(with: cakeEntity)

        // Добавляем или обновляем начинки
        let savedFillings = saveOrUpdateFillingsInMemory(entities: cakeEntity.fillings, using: modelContext)

        // Добавляем или обновляем начинки
        let savedCategories = saveOrUpdateCategoriesInMemory(entities: cakeEntity.categories, using: modelContext)

        // Обновляем изображения торта
        let images = saveOrUpdateCakeImagesInMemory(entities: cakeEntity.images, using: modelContext)

        // Присваиваем связи
        sdCake.fillings = savedFillings
        sdCake.categories = savedCategories
        sdCake.images = images
        
        do {
            try modelContext.save()
        } catch {
            Logger.log(kind: .error, "ошибка сохранения данных торта: \(error)")
        }
    }
    
    /// Достаём список тортов из памяти устройства.
    /// - Parameter modelContext: Контекст контейнера SwiftData
    /// - Returns: Список тортов
    @MainActor
    func fetchCakesFromMemory(using modelContext: ModelContext) async throws -> [SDCake] {
        let fetchDescripor = FetchDescriptor<SDCake>()
        return try modelContext.fetch(fetchDescripor)
    }
    
    /// Достаём список категорий
    /// - Parameters:
    ///   - modelContext: Контекст контейнера SwiftData
    /// - Returns: Список категорий и их торты
    @MainActor
    func fetchCategoriesFromMemory(using modelContext: ModelContext) async throws -> [SDCategory] {
        let fetchDescriptor = FetchDescriptor<SDCategory>()
        return try modelContext.fetch(fetchDescriptor)
    }

    /// Достаём все данные торта из памяти устройства.
    /// - Parameters:
    ///   - cakeID: Код торта
    ///   - modelContext: Контекст контейнера SwiftData
    /// - Returns: Все данные торта, включая изображения, начинки, категории, данные продавца.
    @MainActor
    func fetchCakeFromMemory(cakeID: String, using modelContext: ModelContext) async throws -> SDCake? {
        let predicate = #Predicate<SDCake> { $0.cakeID == cakeID }
        return try modelContext.fetchFirst(predicate: predicate)
    }
    
    /// Достаём данные пользователя из памяти устройства.
    /// - Parameters:
    ///   - userID: Код пользователя
    ///   - modelContext: Контекст контейнера SwiftData
    /// - Returns: Данные пользователя и его торты.
    @MainActor
    func fetchUserFromMemory(userID: String, using modelContext: ModelContext) async throws -> SDUser? {
        let predicate = #Predicate<SDUser> { $0.userID == userID }
        return try modelContext.fetchFirst(predicate: predicate)
    }

    @MainActor
    func fetchCategoryFromMemory(categoryID: String, using modelContext: ModelContext) async throws -> SDCategory? {
        let predicate = #Predicate<SDCategory> { $0.categoryID == categoryID }
        return try modelContext.fetchFirst(predicate: predicate)
    }

}

// MARK: - Helpers

private extension SDMemoryManager {

    @MainActor
    func saveOrUpdateUserInMemory(userEntity: UserEntity, using modelContext: ModelContext) -> SDUser {
        // Если пользователь существует, обновляем. Иначе сохраняем
        let userID = userEntity.id
        let predicate = #Predicate<SDUser> { $0.userID == userID }
        guard let sdUser = try? modelContext.fetchFirst(predicate: predicate) else {
            let sdUser = SDUser(from: userEntity)
            modelContext.insert(sdUser)
            return sdUser
        }

        sdUser.update(with: userEntity)
        return sdUser
    }

    @MainActor
    func saveOrUpdateFillingsInMemory(entities: [FillingEntity], using modelContext: ModelContext) -> [SDFilling] {
        var result: [SDFilling] = []
        result.reserveCapacity(entities.count)

        for fillingEntity in entities {
            // Если начинка существует, обновляем. Иначе сохраняем
            let fillingID = fillingEntity.id
            let predicate = #Predicate<SDFilling> { $0.fillingID == fillingID }
            guard let sdFilling = try? modelContext.fetchFirst(predicate: predicate) else {
                let sdFilling = SDFilling(from: fillingEntity)
                modelContext.insert(sdFilling)
                result.append(sdFilling)
                continue
            }

            sdFilling.update(with: fillingEntity)
            result.append(sdFilling)
        }

        return result
    }

    @MainActor
    func saveOrUpdateCategoriesInMemory(entities: [CategoryEntity], using modelContext: ModelContext) -> [SDCategory] {
        var result: [SDCategory] = []
        result.reserveCapacity(entities.count)

        for categoryEntity in entities {
            // Если категория существует, обновляем. Иначе сохраняем
            let categoryID = categoryEntity.id
            let predicate = #Predicate<SDCategory> { $0.categoryID == categoryID }
            guard let sdCategory = try? modelContext.fetchFirst(predicate: predicate) else {
                let sdCategory = SDCategory(from: categoryEntity)
                modelContext.insert(sdCategory)
                result.append(sdCategory)
                continue
            }

            sdCategory.update(with: categoryEntity)
            result.append(sdCategory)
        }

        return result
    }

    @MainActor
    func saveOrUpdateCakeImagesInMemory(entities: [CakeEntity.CakeImageEntity], using modelContext: ModelContext) -> [SDCakeImage] {
        var result: [SDCakeImage] = []
        result.reserveCapacity(entities.count)

        for imageEntity in entities {
            let imageID = imageEntity.id
            let predicate = #Predicate<SDCakeImage> { $0.imageID == imageID }
            guard let sdCakeImage = try? modelContext.fetchFirst(predicate: predicate) else {
                let sdCakeImage = SDCakeImage(from: imageEntity)
                modelContext.insert(sdCakeImage)
                result.append(sdCakeImage)
                continue
            }

            sdCakeImage.updated(with: imageEntity)
            result.append(sdCakeImage)
        }

        return result
    }

}

// MARK: - ModelContext

private extension ModelContext {

    func fetchFirst<T: PersistentModel>(predicate: Predicate<T>) throws -> T? {
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        return try fetch(descriptor).first
    }

}
