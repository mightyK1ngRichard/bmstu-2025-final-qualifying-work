//
//  StubGrpcCakeService.swift
//  Tорт&LandTests
//
//  Created by Dmitriy Permyakov on 26.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
@testable import NetworkAPI

final class StubGrpcCakeServiceImpl: CakeGrpcService {
    func fetchCategoriesByGenderName(gender: NetworkAPI.CategoryGender) async throws -> NetworkAPI.CakeServiceModel.FetchCategoriesByGenderName.Response {
        fatalError("No implementation")
    }
    
    func fetchCategoryCakes(categoryID: String) async throws -> NetworkAPI.CakeServiceModel.FetchCategoryCakes.Response {
        fatalError("No implementation")
    }

    func createCake(req: CakeServiceModel.CreateCake.Request) async throws -> CakeServiceModel.CreateCake.Response {
        fatalError("No implementation")
    }
    
    func createCategory(req: CakeServiceModel.CreateCategory.Request) async throws -> CakeServiceModel.CreateCategory.Response {
        fatalError("No implementation")
    }
    
    func createFilling(req: CakeServiceModel.CreateFilling.Request) async throws -> CakeServiceModel.CreateFilling.Response {
        fatalError("No implementation")
    }
    
    func fetchFillings() async throws -> CakeServiceModel.FetchFillings.Response {
        fatalError("No implementation")
    }
    
    func fetchCategories() async throws -> CakeServiceModel.FetchCategories.Response {
        fatalError("No implementation")
    }
    
    func fetchCakes() async throws -> CakeServiceModel.FetchCakes.Response {
        fatalError("No implementation")
    }
    
    func fetchCakeDetails(cakeID: String) async throws -> CakeEntity {
        fatalError("No implementation")
    }
    
    func closeConnection() {}
}
