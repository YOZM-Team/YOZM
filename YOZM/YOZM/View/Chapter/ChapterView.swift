//
//  ChapterView.swift
//  YOZM
//
//  Created by 정희균 on 9/3/25.
//

import SwiftUI

struct ChapterView: View {
    @State private var viewModel: ChapterViewModel

    init(viewModel: ChapterViewModel = ChapterViewModel()) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.chapter.stages.reversed(), id: \.id) {
                    stage in
                    StageView(
                        stage: stage,
                        availableWords: viewModel.availableWords
                    )
                }
            }
            .padding()
            .safeAreaPadding(.vertical, 64)
            .frame(maxWidth: .infinity)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .named("ScrollView"))
            } action: { frame in
                viewModel.setScrollViewFrame(frame)
            }
        }
        .coordinateSpace(name: "ScrollView")
        .defaultScrollAnchor(.bottom)
        .frame(maxHeight: .infinity)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { size in
            viewModel.setScrollViewSize(size)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "BFE3D9"),
                    Color(hex: "FFF5E0"),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: viewModel.backgroundHeight)
            .offset(y: viewModel.backgroundOffsetY),
            alignment: .top
        )
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack {
        ChapterView()
    }
}
