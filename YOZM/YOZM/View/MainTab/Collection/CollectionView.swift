//
//  CollectionView.swift
//  YOZM
//
//  Created by 최희진 on 9/6/25.
//

import SwiftUI

struct CollectionView: View {
    @State private var viewModel: CollectionViewModel

    init(viewModel: CollectionViewModel = CollectionViewModel()) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            background

            VStack(spacing: Spacing.lg) {
                navigationBar

                ScrollView {
                    LazyVStack(spacing: Spacing.lg) {
                        cityCollection

                        landmarkCollection
                    }
                }
            }
            .padding(Spacing.lg)
        }
    }

    private var background: some View {
        StudyBackground()
    }

    private var navigationBar: some View {
        HStack {
            Text("Collection")
                .font(.title2)
                .bold()
                .foregroundStyle(.blackNormal)

            Spacer()
        }
    }

    private var cityCollection: some View {
        Section {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(spacing: 0),
                    count: 2
                )
            ) {
                ForEach(viewModel.cities, id: \.self) { city in
                    VStack {
                        Image(city)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, Spacing.xl)
                        Text(city)
                            .font(.caption.bold())
                            .foregroundStyle(.blackNormal)
                    }
                }
            }
        } header: {
            Text("City")
                .font(.headline)
                .foregroundStyle(.blackNormal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var landmarkCollection: some View {
        Section {
            LazyVGrid(
                columns: Array(repeating: GridItem(), count: 2)
            ) {
                ForEach(viewModel.landmarks, id: \.self) {
                    landmark in
                    VStack {
                        Image(landmark)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, Spacing.xl)
                        Text(landmark)
                            .font(.caption.bold())
                            .foregroundStyle(.blackNormal)
                    }
                }
            }
        } header: {
            Text("Landmark")
                .font(.headline)
                .foregroundStyle(.blackNormal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    CollectionView()
}
