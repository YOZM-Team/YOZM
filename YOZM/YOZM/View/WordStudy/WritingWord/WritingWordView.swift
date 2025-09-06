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

            VStack(spacing: Spacing.xl) {
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
        .padding(.vertical, Spacing.lg)
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: 480)
        .background(StudyCardBackground())
        .onAppear {
            GoogleAnalyticsService.shared.inputWordTestStarted(
                wordId: viewModel.word.id
            )
        }
        .onDisappear {
            GoogleAnalyticsService.shared.inputWordTestCompleted(
                wordId: viewModel.word.id,
                correct: viewModel.isCorrect,
                attempts: 0
            )
        }
    }
}

#Preview {
    WritingWordView()
}
