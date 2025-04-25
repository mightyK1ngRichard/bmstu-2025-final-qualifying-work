//
//  AddProductImages.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 07.04.2024.
//  Copyright 2024 © VKxBMSTU Team CakesHub. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddProductImages: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @Bindable var viewModel: CreateProductViewModel
    var backAction: TLVoidBlock

    var body: some View {
        VStack {
            backButton
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 8)

            Text("Select product photos")
                .style(18, .semibold, TLColor<TextPalette>.textPrimary.color)
                .padding(.top)

            imagesContainer
            Spacer()
        }
        .overlay(alignment: .bottom) {
            photoPicker
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear(perform: viewModel.onAppearAddProductImages)
    }
}

// MARK: - Subviews

private extension AddProductImages {

    var imagesContainer: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.uiProperties.selectedPhotosData, id: \.self) { data in
                    if let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 250)
                            .clipShape(.rect(cornerRadius: 16))
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
        .padding(.top)
    }

    var photoPicker: some View {
        PhotosPicker(
            selection: $selectedItems,
            selectionBehavior: .continuous,
            matching: .images,
            preferredItemEncoding: .automatic
        ) {
        }
        .foregroundStyle(.red)
        .onChange(of: selectedItems, viewModel.updateImages)
        .photosPickerStyle(.inline)
        .frame(height: 350)
        .photosPickerDisabledCapabilities([.selectionActions])
        .photosPickerAccessoryVisibility(.hidden)
    }

    var backButton: some View {
        Button(action: backAction, label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(TLColor<IconPalette>.iconPrimary.color)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.bar, in: .rect(cornerRadius: 10))
        })
    }
}
