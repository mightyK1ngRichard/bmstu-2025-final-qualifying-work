//
//  CreateFilling.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 13.05.2025.
//

import SwiftUI

struct CreateFillingModal: View {
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var imageData: Data? = nil
    @State private var content: String = ""
    @State private var kgPrice: String = ""
    @State private var description: String = ""

    @State private var showImagePicker = false
    @State private var selectedImage: NSImage? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Создать категорию")
                .font(.title)
                .bold()

            TextField("Название", text: $name)

            Button {

            } label: {
                Label("Добавить изображние", systemImage: "photo.badge.plus")
            }

            if let selectedImage {
                Image(nsImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }

            HStack {
                Spacer()
                Button("Отмена") {
                    dismiss()
                }
                Button("Сохранить") {
                    saveFilling()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .frame(width: 400)
    }

    private func saveFilling() {
        guard !name.isEmpty,
              let price = Double(kgPrice),
              let imageData = imageData else {
            return
        }

//        let newFilling = Filling(
//            name: name,
//            imageData: imageData,
//            content: content,
//            kgPrice: price,
//            description: description
//        )

        // Тут передай начинку во viewModel или callback
//        print("Создана начинка: \(newFilling)")
    }
}
#Preview {
    CreateFillingModal()
}

import AppKit

struct ImagePicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var image: NSImage?
    @Binding var imageData: Data?

    var body: some View {
        VStack {
            Image(systemName: "photo.badge.plus")

//            Button("Выбрать изображение") {
//                let panel = NSOpenPanel()
//                panel.allowedContentTypes = [.png, .jpeg, .heic, .tiff]
//                panel.canChooseFiles = true
//                panel.canChooseDirectories = false
//                panel.allowsMultipleSelection = false
//
//                if panel.runModal() == .OK,
//                   let url = panel.url,
//                   let nsImage = NSImage(contentsOf: url),
//                   let data = try? Data(contentsOf: url) {
//                    self.image = nsImage
//                    self.imageData = data
//                    dismiss()
//                }
//            }
        }
        .frame(width: 300, height: 200)
    }
}
