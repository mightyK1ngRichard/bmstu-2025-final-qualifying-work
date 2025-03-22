//
//  TestAuthAPIView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation
import NetworkAPI
import SwiftUI

struct CategoryTestView: View {
    let cakeAPI = CakeGrpcServiceImpl(
        configuration: AppHosts.cake,
        networkService: {
            let networkImpl = NetworkServiceImpl()
            networkImpl.setAccessToken(
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDI2ODYwNDEsInVzZXJJRCI6ImIyOWFkYmE5LTc3OWEtNDU0Ny1hNGJhLTlhNmM5ZGVjNjMzZCJ9.HURsDYckofT3oXFiXppUh3ybOxwSeI7dgU5cR3A4uBQ"
            )
            return networkImpl
        }()
    )
    @State private var categoriesData: [CategoryEntity] = []

    var body: some View {
        VStack {
            categories

            Button("Детали торта") {
                fetchCake()
            }
            .buttonStyle(.borderedProminent)

            Button("Создать торт") {
                createCake()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)

            Button("Получить торты") {
                fetchCakes()
            }
            .buttonStyle(.borderedProminent)

            Button("Создать категории") {
                createCategories()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)

            Button("Получить категории") {
                fetchCategories()
            }
            .buttonStyle(.borderedProminent)

            Button("Создать начинки") {
                createFillings()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)

            Button("Получить начинки") {
                fetchFillings()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func fetchCake() {
        Task {
            let res = try await cakeAPI.fetchCakeDetails(cakeID: "980bd52d-0dda-4754-8457-a73ccc602a32")
            print("[DEBUG]: \(res)")
        }
    }

    private func createCake() {
        Task {
            do {
                let res = try await cakeAPI.createCake(
                    req: .init(
                        name: "Торт - Китайский",
                        previewImageData: UIImage.cake3.pngData()!,
                        kgPrice: 1600,
                        rating: 4,
                        description: "Это просто описание очено вкусного торта",
                        mass: 2,
                        isOpenForSale: true,
                        fillingIDs: [
                            "2e66cf65-40af-4640-b591-27acb695b402",
                            "edfb25c2-2170-44d8-bcfe-feeea52aab3d"
                        ],
                        categoryIDs: [
                            "6753cd50-1d19-491a-aa1a-1478dc3670ad",
                            "415491d2-2b80-4c7f-850c-608484777961"
                        ],
                        imagesData: [
                            UIImage.cake1.pngData()!,
                            UIImage.cake2.pngData()!
                        ]
                    )
                )

                print("[DEBUG]: \(res)")
            } catch {
                print("[DEBUG]: \(error)")
            }
        }
    }

    private func fetchCakes() {
        Task {
            do {
                let res = try await cakeAPI.fetchCakes()
                print("[DEBUG]: \(res)")
            } catch {
                print("[DEBUG]: \(error)")
            }
        }
    }

    private func createFillings() {
        [
            ("Шоколадная начинка", UIImage.filling2.pngData()!, "шоколадной", "шоколад"),
            ("Клубничная начинка", UIImage.filling1.pngData()!, "клубничной", "клубника"),
        ].forEach { data in
            Task {
                do {
                    let res = try await cakeAPI.createFilling(
                        req: .init(
                            name: data.0,
                            imageData: data.1,
                            content: data.3,
                            kgPrice: Double.random(in: 1000...2000),
                            description: "Просто описание \(data.2) начинки"
                        )
                    )
                    print("[DEBUG]: \(res)")
                } catch {
                    print("[DEBUG]: \(error)")
                }
            }
        }
    }

    private func fetchFillings() {
        Task {
            do {
                let fillings = try await cakeAPI.fetchFillings()
                print("[DEBUG]: \(fillings)")
            } catch {
                print("[DEBUG]: \(error)")
            }
        }
    }

    private func createCategories() {
        [
            ("Свадебные",  UIImage.categ1.pngData()!),
            ("Спортивные", UIImage.categ2.pngData()!),
            ("Новогодние", UIImage.categ3.pngData()!),
            ("Фруктовые",  UIImage.categ4.pngData()!),
            ("Шоколадные", UIImage.categ5.pngData()!),
        ].forEach { category in
            Task {
                do {
                    let res = try await cakeAPI.createCategory(
                        req: .init(
                            name: category.0,
                            imageData: category.1
                        )
                    )
                    print("[DEBUG]: \(res)")
                } catch {
                    print("[DEBUG]: \(error)")
                }
            }
        }
    }

    private func fetchCategories() {
        Task {
            do {
                categoriesData = try await cakeAPI.fetchCategories().categories
                categoriesData.forEach {
                    print("[DEBUG]: \($0.id)")
                }
            } catch {
                print("[DEBUG]: \(error)")
            }
        }
    }
}

private extension CategoryTestView {

    var categories: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(categoriesData, id: \.id) { cat in
                    VStack {
                        AsyncImage(url: URL(string: cat.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }

                        Text(cat.name)
                            .font(.headline)
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryTestView()
}
