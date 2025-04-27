//
//  OrderView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 27.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI

extension OrderViewModel {
    struct UIProperties: Hashable {
        var state: ScreenState = .initial
    }
}

@Observable
final class OrderViewModel {
    var uiProperties = UIProperties()
    private(set) var cake: CakeModel?
    private let cakeID: String
    @ObservationIgnored
    private let cakeProvider: CakeService

    init(cakeID: String, cakeProvider: CakeService) {
        self.cakeID = cakeID
        self.cakeProvider = cakeProvider
    }
}

extension OrderViewModel {

    func fetchCakeInfo() {
        uiProperties.state = .loading
        Task { @MainActor in
            do {
                let cakeEntity = try await cakeProvider.fetchCakeDetails(cakeID: cakeID)
                cake = CakeModel(from: <#T##PreviewCakeEntity#>)
                uiProperties.state = .finished
            } catch {
                uiProperties.state = .error(message: "\(error)")
            }
        }
    }

}

struct OrderView: View {
    @State var viewModel: OrderViewModel

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    OrderView(
        viewModel: OrderViewModel(
            cakeID: "",
            cakeProvider: CakeGrpcServiceImpl(
                configuration: AppHosts.cake,
                networkService: {
                    let network = NetworkServiceImpl()
                    network.setRefreshToken(CommonMockData.refreshToken)
                    return network
                }()
            )
        )
    )
}
