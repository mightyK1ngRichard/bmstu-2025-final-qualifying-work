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
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDIxNjQ4NzgsInVzZXJJRCI6IjRkYzkwOGM0LWEwYzEtNDMyNi1iMWY5LTI3Y2MzNzg2MDJiNCJ9.o505EF2mBVD-EmmPc_gzRn-KeJv5cuGKS1uOtLAuSQM"
            )
            return networkImpl
        }()
    )
    @State private var categoriesData: [CakeServiceModel.FetchCategories.Response] = []

    var body: some View {
        VStack {
            categories

            Button("Создать торт") {
                createCake()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)

            Button("Получить торты") {
                fetchCake()
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

            Button("Получить начинка") {
                fetchFillings()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func createCake() {
        Task {
            do {
                let res = try await cakeAPI.createCake(
                    req: .init(
                        name: "Моковый клубничный торт",
                        imageData: UIImage.cake2.pngData()!,
                        kgPrice: 1200,
                        rating: 0,
                        description: "Это просто описание мокового торта",
                        mass: 3000,
                        isOpenForSale: true,
                        fillingIDs: [
                            "09771d07-f9e1-4dc0-8a54-d58aa584c2b3",
                            "785617a2-03ae-4209-b878-529535a4dc4c"
                        ],
                        categoryIDs: [
                            "ad7af6f9-9c29-4b49-b854-f13e42e5729d",
                            "fd45f8b9-fcf8-482c-a56b-213fbc639752",
                        ]
                    )
                )

                print("[DEBUG]: \(res)")
            } catch {
                print("[DEBUG]: \(error)")
            }
        }
    }

    private func fetchCake() {
        Task {
//            do {
//            } catch {
//                print("[DEBUG]: \(error)")
//            }
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
                categoriesData = try await cakeAPI.fetchCategories()
                print("id: \(categoriesData.map { $0.id })\n")
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
