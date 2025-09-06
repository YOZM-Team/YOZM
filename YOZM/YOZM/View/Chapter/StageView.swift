//
//  StageView.swift
//  YOZM
//
//  Created by 정희균 on 9/4/25.
//

import SwiftUI

struct StageView: View {
    let stage: Stage
    let availableWords: [Int64: Bool]

    var body: some View {
        VStack {
            ForEach(stage.words.indices, id: \.self) { index in
                HStack {
                    if StageLayout.spacerPositions.contains(
                        index % StageLayout.stageItemCount
                    ) {
                        Spacer()
                    }

                    let newIndex = stage.words.count - index - 1
                    StageTileView(stage: stage, index: newIndex)
                        .disabled(
                            availableWords[stage.words[newIndex].id] == false
                        )

                    if index % StageLayout.stageItemCount
                        == StageLayout.centerPosition
                    {
                        Spacer()
                    }
                }
            }
        }
    }

    private enum StageLayout {
        static let stageItemCount = 5
        static let spacerPositions = [0, 4]
        static let centerPosition = 2
    }
}

#Preview {
    NavigationStack {
        StageView(stage: .sample, availableWords: [:])
    }
}
