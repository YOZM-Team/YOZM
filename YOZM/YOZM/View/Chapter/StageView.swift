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
                    if index % 5 == 0 || index % 5 == 4 {
                        Spacer()
                    }

                    let newIndex = stage.words.count - index - 1
                    StageTileView(stage: stage, index: newIndex)
                        .disabled(
                            availableWords[stage.words[newIndex].id] == false
                        )

                    if index % 5 == 2 {
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StageView(stage: .sample, availableWords: [:])
    }
}
