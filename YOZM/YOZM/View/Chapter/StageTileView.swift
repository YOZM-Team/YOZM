//
//  StageTileView.swift
//  YOZM
//
//  Created by 정희균 on 9/4/25.
//

import SwiftUI

struct StageTileView: View {
    let stage: Stage
    let index: Int

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        NavigationLink {
            if stage.words.indices.contains(index) {
                let word = stage.words[index]
                let viewModel = WordStudyViewModel(word: word)
                WordStudyView(viewModel: viewModel)
                    .toolbar(.hidden, for: .navigationBar)
            }
        } label: {
            Image(
                uiImage: tileImageFromStageIndex(
                    stageTitle: stage.title,
                    index: index
                )
            )
            .resizable()
            .scaledToFit()
            .frame(maxWidth: index == 4 ? 160 : 128)
            .saturation(isEnabled ? 1.0 : 0.0)
        }
    }

    private func tileImageFromStageIndex(stageTitle: String, index: Int)
        -> UIImage
    {
        if let image = UIImage(named: "\(stageTitle)\(index + 1)") {
            return image
        }
        return .lotteWorldTower1
    }
}

#Preview {
    NavigationStack {
        StageTileView(stage: .sample, index: 0)
    }
}
