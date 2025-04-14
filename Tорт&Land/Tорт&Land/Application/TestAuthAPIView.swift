//import Foundation
//import NetworkAPI
//import SwiftUI
//
//let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDQzMTYyNDUsInVzZXJJRCI6IjZjNzM0YTE3LTM3NDktNDM2OS05ZGQ5LWJjNWZhYTVkYjUxNCJ9.hMB6z2iX6UKkBldcLOdclhsTuJGSngy_Xv_tjuxM5G4"
//
//let refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDQ4MTkwMDcsInVzZXJJRCI6IjZjNzM0YTE3LTM3NDktNDM2OS05ZGQ5LWJjNWZhYTVkYjUxNCJ9.oDLm3dhlOJrVrvPvKyvLC7HBL6nY-xK48sTNoiKUlD0"
//
//fileprivate let networkImpl = NetworkServiceImpl()
//
//fileprivate let authAPI = AuthGrpcServiceImpl(
//    configuration: AppHosts.auth,
//    networkService: networkImpl
//)
//
//struct CategoryTestView: View {
//    let cakeAPI = CakeGrpcServiceImpl(
//        configuration: AppHosts.cake,
//        networkService: {
//            let networkImpl = NetworkServiceImpl()
//            networkImpl.setAccessToken(accessToken, expiresIn: .now)
//            return networkImpl
//        }()
//    )
//
//    let profileAPI = ProfileGrpcServiceImpl(
//        configuration: AppHosts.profile,
//        authService: authAPI,
//        networkService: {
//            let networkImpl = NetworkServiceImpl()
//            networkImpl.setAccessToken(accessToken, expiresIn: .now)
//            return networkImpl
//        }()
//    )
//
//    @State private var categoriesData: [CategoryEntity] = []
//
//    var body: some View {
//        VStack {
//            categories
//
//            Button("update access token") {
//                Task {
//                    let accessToken = try await authAPI.updateAccessToken()
//                    print("[DEBUG]: \(accessToken)")
//                }
//            }
//            .buttonStyle(.borderedProminent)
//            .tint(.purple)
//
//            Button("Get user info") {
//                Task {
//                    let res = try await profileAPI.getUserInfo()
//                    print("[DEBUG]: \(res)")
//                }
//            }
//
//            Button("Cake with categories") {
//                Task {
//                    async let fil1 = try cakeAPI.createFilling(
//                        req: .init(
//                            name: "Клубничная начинка",
//                            imageData: UIImage.filling1.jpegData(compressionQuality: 1)!,
//                            content: "Клубника, коржик, сливки",
//                            kgPrice: 1000,
//                            description: "Это очень вкусная клубничная начинка"
//                        )
//                    )
//
//                    async let fil2 = try cakeAPI.createFilling(
//                        req: .init(
//                            name: "Шоколадная начинка",
//                            imageData: UIImage.filling2.jpegData(compressionQuality: 1)!,
//                            content: "Шоколад, сироп, сливки",
//                            kgPrice: 1200,
//                            description: "Это очень вкусная шоколадная начинка"
//                        )
//                    )
//
//                    async let cat1 = try cakeAPI.createCategory(
//                        req: .init(
//                            name: "Свадебные",
//                            imageData: UIImage.categ1.jpegData(compressionQuality: 1)!
//                        )
//                    )
//
//                    async let cat2 = try cakeAPI.createCategory(
//                        req: .init(
//                            name: "Клубничные",
//                            imageData: UIImage.categ4.jpegData(compressionQuality: 1)!
//                        )
//                    )
//
//                    let (filRes1, filRes2, catRes1, catRes2) = try await (fil1, fil2, cat1, cat2)
//                    _ = try await cakeAPI.createCake(
//                        req: .init(
//                            name: "Торт Прага - свадебный",
//                            previewImageData: UIImage.cake1.jpegData(compressionQuality: 1)!,
//                            kgPrice: 3000,
//                            rating: 5,
//                            description: "Это очень вкусный торт прага, который буквально таит во рту",
//                            mass: 2,
//                            isOpenForSale: true,
//                            fillingIDs: [
//                                filRes1.filling.id,
//                                filRes2.filling.id,
//                            ],
//                            categoryIDs: [
//                                catRes1.category.id,
//                                catRes2.category.id,
//                            ],
//                            imagesData: [
//                                UIImage.cake2.jpegData(compressionQuality: 1)!,
//                                UIImage.cake3.jpegData(compressionQuality: 1)!,
//                            ]
//                        )
//                    )
//                }
//            }
//
//            Button("Детали торта") {
//                fetchCake()
//            }
//            .buttonStyle(.borderedProminent)
//
//            Button("Создать торт") {
//                createCake()
//            }
//            .buttonStyle(.borderedProminent)
//            .tint(.red)
//
//            Button("Получить торты") {
//                fetchCakes()
//            }
//            .buttonStyle(.borderedProminent)
//
//            Button("Создать категории") {
//                createCategories()
//            }
//            .buttonStyle(.borderedProminent)
//            .tint(.red)
//
//            Button("Получить категории") {
//                fetchCategories()
//            }
//            .buttonStyle(.borderedProminent)
//
//            Button("Создать начинки") {
//                createFillings()
//            }
//            .buttonStyle(.borderedProminent)
//            .tint(.red)
//
//            Button("Получить начинки") {
//                fetchFillings()
//            }
//            .buttonStyle(.borderedProminent)
//        }
//    }
//
//    private func fetchCake() {
//        Task {
//            let res = try await cakeAPI.fetchCakeDetails(cakeID: "980bd52d-0dda-4754-8457-a73ccc602a32")
//            print("[DEBUG]: \(res)")
//        }
//    }
//
//    private func createCake() {
//        Task {
//            do {
//                let res = try await cakeAPI.createCake(
//                    req: .init(
//                        name: "Торт - Китайский",
//                        previewImageData: UIImage.cake3.pngData()!,
//                        kgPrice: 1600,
//                        rating: 4,
//                        description: "Это просто описание очено вкусного торта",
//                        mass: 2,
//                        isOpenForSale: true,
//                        fillingIDs: [
//                            "2e66cf65-40af-4640-b591-27acb695b402",
//                            "edfb25c2-2170-44d8-bcfe-feeea52aab3d"
//                        ],
//                        categoryIDs: [
//                            "6753cd50-1d19-491a-aa1a-1478dc3670ad",
//                            "415491d2-2b80-4c7f-850c-608484777961"
//                        ],
//                        imagesData: [
//                            UIImage.cake1.pngData()!,
//                            UIImage.cake2.pngData()!
//                        ]
//                    )
//                )
//
//                print("[DEBUG]: \(res)")
//            } catch {
//                print("[DEBUG]: \(error)")
//            }
//        }
//    }
//
//    private func fetchCakes() {
//        Task {
//            do {
//                let res = try await cakeAPI.fetchCakes()
//                print("[DEBUG]: \(res)")
//            } catch {
//                print("[DEBUG]: \(error)")
//            }
//        }
//    }
//
//    private func createFillings() {
//        [
//            ("Шоколадная начинка", UIImage.filling2.pngData()!, "шоколадной", "шоколад"),
//            ("Клубничная начинка", UIImage.filling1.pngData()!, "клубничной", "клубника"),
//        ].forEach { data in
//            Task {
//                do {
//                    let res = try await cakeAPI.createFilling(
//                        req: .init(
//                            name: data.0,
//                            imageData: data.1,
//                            content: data.3,
//                            kgPrice: Double.random(in: 1000...2000),
//                            description: "Просто описание \(data.2) начинки"
//                        )
//                    )
//                    print("[DEBUG]: \(res)")
//                } catch {
//                    print("[DEBUG]: \(error)")
//                }
//            }
//        }
//    }
//
//    private func fetchFillings() {
//        Task {
//            do {
//                let fillings = try await cakeAPI.fetchFillings()
//                print("[DEBUG]: \(fillings)")
//            } catch {
//                print("[DEBUG]: \(error)")
//            }
//        }
//    }
//
//    private func createCategories() {
//        [
//            ("Свадебные",  UIImage.categ1.pngData()!),
//            ("Спортивные", UIImage.categ2.pngData()!),
//            ("Новогодние", UIImage.categ3.pngData()!),
//            ("Фруктовые",  UIImage.categ4.pngData()!),
//            ("Шоколадные", UIImage.categ5.pngData()!),
//        ].forEach { category in
//            Task {
//                do {
//                    let res = try await cakeAPI.createCategory(
//                        req: .init(
//                            name: category.0,
//                            imageData: category.1
//                        )
//                    )
//                    print("[DEBUG]: \(res)")
//                } catch {
//                    print("[DEBUG]: \(error)")
//                }
//            }
//        }
//    }
//
//    private func fetchCategories() {
//        Task {
//            do {
//                categoriesData = try await cakeAPI.fetchCategories().categories
//                categoriesData.forEach {
//                    print("[DEBUG]: \($0.id)")
//                }
//            } catch {
//                print("[DEBUG]: \(error)")
//            }
//        }
//    }
//
//}
//
//private extension CategoryTestView {
//
//    var categories: some View {
//        ScrollView(.horizontal) {
//            HStack {
//                ForEach(categoriesData, id: \.id) { cat in
//                    VStack {
//                        AsyncImage(url: URL(string: cat.imageURL)) { image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 50, height: 50)
//                        } placeholder: {
//                            ProgressView()
//                        }
//
//                        Text(cat.name)
//                            .font(.headline)
//                    }
//                }
//            }
//        }
//    }
//
//}
//
//#Preview {
//    CategoryTestView()
//}

import SwiftUI
import NetworkAPI

struct TestAuthAPIView: View {
    let cakeProvider = CakeGrpcServiceImpl(
        configuration: AppHosts.cake,
        networkService: {
            let networkService = NetworkServiceImpl()
            networkService.setRefreshToken(
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDQ2MTc1MzYsInVzZXJJRCI6IjhjMjhhNDY0LWY0ZjEtNGVlMy05MjI5LTgwMWIyMWRhODc4MyJ9.Z-nMk8hxoi4QNkWjIljh4WVLQd7IG5fnt81powleqDs"
            )
            return networkService
        }()
    )

    var body: some View {
        Button("Update token") {
            Task {
                do {
                    let res = try await cakeProvider.fetchCategoriesByGenderName(gender: .male)
                    print("[DEBUG]: \(res)")
                } catch {
                    print("[DEBUG]: \(error)")
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    TestAuthAPIView()
}
