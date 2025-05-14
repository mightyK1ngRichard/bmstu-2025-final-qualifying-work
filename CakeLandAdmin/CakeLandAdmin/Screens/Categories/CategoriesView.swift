//
//  CategoriesView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 13.05.2025.
//

import SwiftUI
import AppKit
import MacCore

struct CategoriesView: View {
    @State var viewModel: CategoriesViewModel

    var body: some View {
        List {
            categoriesContainer
            fillingsContainer
            colorsContainer
        }
        .sheet(isPresented: $viewModel.bindingData.isShowingSheet) {
            sheetContent
        }
        .defaultAlert(
            errorContent: viewModel.bindingData.alert.content,
            isPresented: $viewModel.bindingData.alert.isShown
        )
        .onFirstAppear {
            viewModel.fetchCategories()
            viewModel.fetchFillings()
            viewModel.fetchColors()
        }
    }

    private let columns = [
        GridItem(.adaptive(minimum: 280, maximum: 400))
    ]
}

// MARK: - UI Subviews

private extension CategoriesView {

    var categoriesContainer: some View {
        Section(header: Text("Категории").font(.title2).bold()) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.categories) { category in
                    categoryCard(for: category)
                }

                AddFillingButton(title: "Добавить категорию", action: viewModel.didTapAddCategoryButton)
                    .frame(minHeight: 150)
            }
        }
    }

    var fillingsContainer: some View {
        Section(header: Text("Начинки").font(.title2).bold()) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.fillings) { filling in
                    fillingCard(for: filling)
                }

                AddFillingButton(title: "Добавить начинку", action: viewModel.didTapAddFillingButton)
                    .frame(minHeight: 150)
            }
        }
    }

    var colorsContainer: some View {
        Section(header: Text("Цвета").font(.title2).bold()) {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 10),
                spacing: 16
            ) {
                ForEach(viewModel.colorsHex, id: \.self) { hex in
                    Color(hex: hex)
                        .frame(height: 40)
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0.1))
                        )
                }
            }
        }
    }

    func fillingCard(for filling: Filling) -> some View {
        VStack(alignment: .leading) {
            TLImageView(
                configuration: .init(imageState: filling.thumbnail.imageState)
            )
            .frame(height: 150)
            .clipShape(.rect(cornerRadius: 10))

            Text(filling.name)
                .font(.headline)
            Text(filling.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Цена: \(viewModel.configurePriceTitle(price: filling.kgPrice))")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
    }

    func categoryCard(for category: Category) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            TLImageView(
                configuration: .init(imageState: category.thumbnail.imageState)
            )
            .frame(height: 150)
            .clipShape(.rect(cornerRadius: 10))

            Text(category.name)
                .font(.headline)

            Text(category.genderTags.map(\.rawValue).joined(separator: ", "))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
}

// MARK: - Sheet subviews

private extension CategoriesView {

    @ViewBuilder
    var sheetContent: some View {
        switch viewModel.bindingData.sheetKind {
        case .addCategory:
            createCategoryContainer
        case .addFilling:
            createFillingContainer
        }
    }

    var createFillingContainer: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Создать начинку")
                .font(.title)
                .bold()
            TextField("Название", text: $viewModel.bindingData.createFillingModel.inputName)
            TextField("Состав", text: $viewModel.bindingData.createFillingModel.inputContent)
            TextField("Цена за кг", text: $viewModel.bindingData.createFillingModel.inputKgPrice)
            TextField("Описание", text: $viewModel.bindingData.createFillingModel.inputDescription)

            Button {
                viewModel.pickImage()
            } label: {
                Label("Добавить изображние", systemImage: "photo.badge.plus")
            }

            if let selectedImageData = viewModel.bindingData.selectedImageData,
               let nsImage = NSImage(data: selectedImageData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(.rect(cornerRadius: 8))
            }

            if let errorMessage = viewModel.bindingData.createFillingModel.inputError {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            HStack {
                Spacer()
                Button("Отмена") {
                    viewModel.didTapCancel()
                }

                Button("Сохранить") {
                    viewModel.didTapCreateFilling()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(viewModel.bindingData.saveNewFillButtonIsDisable)
            }
        }
        .padding()
        .frame(width: 400)
    }

    var createCategoryContainer: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Создать категорию")
                .font(.title)
                .bold()

            TextField("Название", text: $viewModel.bindingData.createCategoryModel.inputName)

            VStack(alignment: .leading, spacing: 8) {
                Text("Выберите гендеры:")
                    .font(.headline)

                ForEach(Category.Gender.allCases, id: \.rawValue) { gender in
                    Toggle(isOn: viewModel.bindingForGender(gender)) {
                        Text(gender.rawValue)
                    }
                }
            }
            .padding()

            Button {
                viewModel.pickImage()
            } label: {
                Label("Добавить изображние", systemImage: "photo.badge.plus")
            }

            if let selectedImageData = viewModel.bindingData.selectedImageData,
               let nsImage = NSImage(data: selectedImageData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(.rect(cornerRadius: 8))
            }

            if let errorMessage = viewModel.bindingData.createFillingModel.inputError {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            HStack {
                Spacer()
                Button("Отмена") {
                    viewModel.didTapCancel()
                }

                Button("Сохранить") {
                    viewModel.didTapCreateCategory()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(viewModel.bindingData.saveNewCategoryButtonIsDisable)
            }
        }
        .padding()
        .frame(width: 400)
    }

}

// MARK: - Preview

#Preview {
    CategoriesView(
        viewModel: CategoriesViewModel(
            networkManager: NetworkManager(),
            imageProvider: ImageLoaderProviderImpl()
        )
    )
    .frame(minWidth: 500, minHeight: 600)
}

// MARK: - Helpers

struct AddFillingButton: View {
    let title: String
    var action: TLVoidBlock?
    @State private var isHovering = false

    var body: some View {
        GeometryReader { geo in
            Button {
                action?()
            } label: {
                VStack(spacing: 16) {
                    Image(systemName: "plus")
                        .font(.title2)
                    Text(title)
                        .multilineTextAlignment(.center)
                        .fontWeight(.medium)
                }
                .padding()
                .frame(width: geo.size.width, height: geo.size.height)
                .background(isHovering ? Color.accentColor.opacity(0.15) : Color.clear, in: .rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isHovering ? Color.accentColor : Color.clear, lineWidth: 1)
                )
                .scaleEffect(isHovering ? 0.95 : 1.0)
                .shadow(color: .black.opacity(isHovering ? 0.2 : 0), radius: 6, x: 0, y: 4)
                .animation(.easeInOut(duration: 0.15), value: isHovering)
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                isHovering = hovering
            }
        }
    }
}
