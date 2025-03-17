//
//  NetworkAPI.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 15.02.2025.
//

import SwiftUI

struct TestAuthAPIView: View {
    let api = CakeGrpcServiceImpl(
        configuration: AppHosts.cake,
        networkService: NetworkServiceImpl()
    )

    @State private var urls: [String] = []
    @State private var fillings: [String] = []

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                VStack {
                    HStack {
                        ForEach(urls, id: \.self) { urlString in
                            AsyncImage(url: URL(string: urlString)) { image in
                                image
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }

                    HStack {
                        ForEach(fillings, id: \.self) { fill in
                            AsyncImage(url: URL(string: fill)) { image in
                                image
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
            }

            Button("Fetch") {
                Task {
                    do {
                        let res = try await api.fetchCategories()
                        urls = res.map { $0.imageURL }
                    } catch {
                        print("[DEBUG]: \(error)")
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Fetch") {
                Task {
                    do {
                        let res = try await api.fetchFillings()
                        fillings = res.map { $0.imageURL }
                    } catch {
                        print("[DEBUG]: \(error)")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    TestAuthAPIView()
}
