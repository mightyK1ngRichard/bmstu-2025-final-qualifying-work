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
        networkService: NetworkServiceImpl()
    )
    @State private var categoriesData: [CakeServiceModel.FetchCategories.Response] = []

    var body: some View {
        VStack {
            categories

            Button("Создать категории") {
                createCategories()
            }
            .buttonStyle(.borderedProminent)

            Button("Получить категории") {
                fetchCategories()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func createCategories() {
        [
            ("Свадебные", UIImage.categ1.pngData()!),
            ("Спортивные", UIImage.categ2.pngData()!),
            ("Новогодние", UIImage.categ3.pngData()!),
            ("Фруктовые", UIImage.categ4.pngData()!),
            ("Шоколадные", UIImage.categ5.pngData()!),
        ].forEach { category in
            Task {
                do {
                    _ = try await cakeAPI.createCategory(
                        req: .init(
                            name: category.0,
                            imageData: category.1
                        )
                    )
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
