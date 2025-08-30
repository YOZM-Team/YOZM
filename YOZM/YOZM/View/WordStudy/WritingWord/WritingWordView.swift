//
//  WritingWordView.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct WritingWordView: View {
    @State private var viewModel: WritingWordViewModel

    init(viewModel: WritingWordViewModel = WritingWordViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            Text("Word Practice")
                .font(.title)
                .bold()
                .foregroundStyle(.blackNormal)

            Spacer()

            Text(viewModel.word.word)
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.blackNormal)

            Spacer()

            VStack(spacing: 32) {
                Text("Type the word")

                StudyTextField(
                    text: Binding(
                        get: {
                            viewModel.text
                        },
                        set: {
                            viewModel.setText($0)
                        }
                    ),
                    correctText: viewModel.word.word,
                    isCorrect: viewModel.isCorrect
                )
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: 480)
        .background(StudyCardBackground())
    }
}

#Preview {
    WritingWordView()
}
