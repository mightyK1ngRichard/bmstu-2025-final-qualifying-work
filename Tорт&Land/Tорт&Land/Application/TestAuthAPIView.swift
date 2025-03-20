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
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDI0NjgzMTAsInVzZXJJRCI6IjA1ZmVlMDhlLTFiMzAtNGJmNy05N2RjLWY4MjNjYzcyMzJiZSJ9.CZLwuZjfTZud3-T6ay64vVe8hjMXxNwLiIY-vv02RGg"
            )
            return networkImpl
        }()
    )
    @State private var categoriesData: [CategoryEntity] = []

    var body: some View {
        VStack {
            categories

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

    private func createCake() {
        Task {
            do {
                let res = try await cakeAPI.createCake(
                    req: .init(
                        name: "Моковый орешковый шоколадный торт",
                        imageData: UIImage.cake3.pngData()!,
                        kgPrice: 1600,
                        rating: 4,
                        description: "Это просто описание мокового торта",
                        mass: 2,
                        isOpenForSale: true,
                        fillingIDs: [
                            "5d97ee9c-0223-4f03-888e-b6e3d2c7f614"
                        ],
                        categoryIDs: [
                            "212e0218-3d36-470e-ac4b-f4ad04d1d162",
                            "eea41ae2-f1a7-412e-9795-0ebf79f59d74",
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
