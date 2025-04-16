//
//  CakesLandApp.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import NetworkAPI

struct ChatTestView: View {
    @State private var messages: [ChatMessageEntity] = []
    let api: ChatServiceImpl

    var body: some View {
        VStack {
            List(messages, id: \.id) { msg in
                VStack {
                    Text(msg.senderID ?? "none")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text(msg.text)
                        .font(.footnote)
                }
            }
            Button("Send message") {
                Task {
                    do {
                        try await api.sendMessage(
                            message: ChatMessageEntity(
                                id: UUID().uuidString,
                                text: "Привет!",
                                interlocutorID: "8b20b7fc-8009-4dc9-a51a-12224f2c626b",
                                dateCreation: Date()
                            )
                        )
                    } catch {
                        print("[DEBUG]: error: \(error)")
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    api.handler = { message in
                        messages.append(message)
                    }
                    try await api.startChat()
                } catch {
                    print("[DEBUG]: \(error)")
                }
            }
        }
    }
}

@main
struct CakesLandApp: App {
    @State private var startScreenControl = StartScreenControl()

    var body: some Scene {
        WindowGroup {
            #if DEBUG
//            RootAssembler.assembleMock()
            RootAssembler.assemble(startScreenControl: startScreenControl)
                .environment(startScreenControl)

//            ChatTestView(
//                api: {
//                    let network = NetworkServiceImpl()
//                    let authService = AuthGrpcServiceImpl(
//                        configuration: AppHosts.auth,
//                        networkService: network
//                    )
//                    network.setRefreshToken(refresh)
//                    let api = ChatServiceImpl(
//                        configuration: AppHosts.chat,
//                        authService: authService,
//                        networkService: network
//                    )
//
//                    return api
//                }()
//            )
            #else
            RootAssembler.assemble(startScreenControl: startScreenControl)
                .environment(startScreenControl)
            #endif
        }
    }
}

let refresh = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDUyNzcwNjEsInVzZXJJRCI6IjY5ZjQwOWZhLWYyYjQtNDllMC04MjE5LWZlNmUyYTAzNWZlMCJ9.Kw3RqyNlrrNN_PP4wJ2P2we-_FKOX5UrOTGn1hyWA4g"
