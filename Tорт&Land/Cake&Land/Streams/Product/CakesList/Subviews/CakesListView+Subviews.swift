//
//  CakesListView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI
import Core
import DesignSystem

extension CakesListView {

    var mainContainer: some View {
        ScrollView {
            VStack(spacing: 0) {
                bannerView
                sectionsContainer
            }
        }
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .background(Constants.bgMainColor)
    }
}

// MARK: - Main Containers

private extension CakesListView {

    var bannerView: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let iscrolling = minY > 0
            let size = geo.size

            TLBannerView(
                configuration: .basic(title: Constants.bannerTitle)
            )
            .frame(height: iscrolling ? size.height + minY : size.height)
            .offset(y: -minY)
            .blur(radius: iscrolling ? 0 + minY / 60 : 0)
            .scaleEffect(iscrolling ? 1 + minY / 2000 : 1)
        }
        .frame(height: 460)
    }

    var sectionsContainer: some View {
        VStack(spacing: 40) {
            switch viewModel.bindingData.screenState {
            case .initial, .loading:
                shimmeringContainer
            case .finished:
                ForEach(viewModel.bindingData.sections) { section in
                    sectionView(for: section)
                }
            case let .error(content):
                errorView(with: content)
            }
        }
        .padding(.vertical, 13)
        .background(Constants.bgMainColor)
        .clipShape(.rect(cornerRadius: 16))
        .padding(.top, -20)
    }

    func errorView(with content: ErrorContent) -> some View {
        TLErrorView(
            configuration: viewModel.configureErrorView(content: content),
            action: viewModel.fetchData
        )
        .padding(.horizontal, 53)
    }

    var shimmeringContainer: some View {
        VStack(spacing: 40) {
            shimmeringSection
            shimmeringSection
            shimmeringSection
        }
    }

    var shimmeringSection: some View {
        VStack(spacing: 22) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    ShimmeringView()
                        .frame(width: 71, height: 34)
                        .clipShape(.capsule)
                    ShimmeringView()
                        .frame(width: 101, height: 11)
                        .clipShape(.capsule)
                }
                Spacer()
                ShimmeringView()
                    .frame(width: 41, height: 11)
                    .clipShape(.capsule)
            }
            .padding(.horizontal)

            ScrollView(.horizontal) {
                HStack(spacing: 18) {
                    ForEach(0...10, id: \.self) { _ in
                        TLProductCard(configuration: viewModel.configureShimmeringProductCard())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Helpers Subviews

private extension CakesListView {

    @ViewBuilder
    func sectionView(for section: CakesListModel.Section) -> some View {
        switch section {
        case let .new(cakeModels):
            cakesSectionView(section: .new, models: cakeModels) {
                viewModel.didTapAllButton(cakeModels, section: .new)
            }
        case let .sale(cakeModels):
            cakesSectionView(section: .sale, models: cakeModels) {
                viewModel.didTapAllButton(cakeModels, section: .sales)
            }
        case let .all(cakeModels):
            cakesSectionView(section: .all, models: cakeModels)
        }
    }

    func cakesSectionView(
        section: CakesListModel.Section.Kind,
        models: [CakeModel],
        action: TLVoidBlock? = nil
    ) -> some View {
        VStack(spacing: 22) {
            sectionHeader(
                title: section.title,
                subtitle: section.subtitle,
                action: action
            )
            .padding(.horizontal)

            switch section {
            case .sale, .new:
                horizontalCakesContainer(section: section, models: models)
            case .all:
                gridCakesContainer(section: section, models: models)
            }
        }
    }

    func horizontalCakesContainer(
        section: CakesListModel.Section.Kind,
        models: [CakeModel]
    ) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(models) { cakeModel in
                    TLProductCard(
                        configuration: viewModel.configureProductCard(
                            model: cakeModel,
                            section: section
                        )
                    ) { isSelected in
                        viewModel.didTapLikeButton(model: cakeModel, isSelected: isSelected)
                    }
                    .frame(width: 148)
                    .onTapGesture {
                        viewModel.didTapCell(model: cakeModel)
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }


    @ViewBuilder
    func gridCakesContainer(
        section: CakesListModel.Section.Kind,
        models: [CakeModel]
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating:  GridItem(), count: 2),
            spacing: Constants.intrinsicHPaddings
        ) {
            ForEach(models) { cakeModel in
                TLProductCard(
                    configuration: viewModel.configureProductCard(
                        model: cakeModel,
                        section: section
                    )
                ) { isSelected in
                    viewModel.didTapLikeButton(model: cakeModel, isSelected: isSelected)
                }
                .onTapGesture {
                    viewModel.didTapCell(model: cakeModel)
                }
            }
        }
        .padding(.horizontal)
    }

    func sectionHeader(
        title: LocalizedStringResource,
        subtitle: LocalizedStringResource,
        action: TLVoidBlock? = nil
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).style(34, .bold)
                Text(subtitle).style(11, .regular, Constants.textSecondary)
            }

            Spacer()

            if let action {
                Button {
                    action()
                } label: {
                    Text(Constants.lookAllTitle).style(11, .regular)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Mockable delay") {
    CakesListView(
        viewModel: CakesListViewModelMock(delay: 2)
    )
    .environment(Coordinator())
}

// MARK: - Constants

private extension CakesListView {
    enum Constants {
        static let lookAllTitle = String(localized: "View all")
        static let bannerTitle = String(localized: "Торт&\nLand")

        static let bgMainColor: Color = TLColor<BackgroundPalette>.bgMainColor.color
        static let textSecondary: Color = TLColor<TextPalette>.textSecondary.color

        static let intrinsicHPaddings: CGFloat = 18
    }
}
