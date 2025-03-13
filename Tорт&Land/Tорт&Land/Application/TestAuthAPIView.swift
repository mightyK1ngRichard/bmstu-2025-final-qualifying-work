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
    let api = CakeGrpcServiceImpl(
        configuration: AppHosts.cake,
        networkService: NetworkServiceImpl()
    )
    @State var imageURL: String? = "http://localhost:9000/cake-land-server/630483c2-f7c4-473a-8860-53f54863b789"

    var body: some View {
        VStack {
            if let imageString = imageURL, let url = URL(string: imageString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(.rect(cornerRadius: 20))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 200)
                }
            } else {
                Text("ERROR")
            }

            Button("Create Category") {
                Task {
                    guard let imageData = UIImage.wedding.pngData() else {
                        print("[DEBUG]: error create image data")
                        return
                    }

                    do {
                        let res = try await api.createCategory(
                            req: .init(name: "Свадебные торты", imageData: imageData)
                        )
                        imageURL = res.imageURL
                    } catch {

                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    CategoryTestView()
}
