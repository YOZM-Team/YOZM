//
//  WordStudyView.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct WordStudyView: View {
    @State private var viewModel: WordStudyViewModel

    init(viewModel: WordStudyViewModel = WordStudyViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            background

            VStack(spacing: 16) {
                navigationBar

                Group {
                    switch viewModel.wordStudyState {
                    case .dialogue:
                        dialogue
                    case .explanation:
                        explanation
                    case .writingWord:
                        writingWord
                    case .speakingSentence:
                        speakingSentence
                    case .writingSentence:
                        writingSentence
                    case .finish:
                        finish
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing)
                            .combined(with: .opacity),
                        removal: .move(edge: .leading)
                            .combined(with: .opacity)
                    )
                )
                .frame(maxHeight: .infinity)

                nextButton
            }
            .padding(24)
        }
    }

    private var background: some View {
        StudyBackground()
    }

    private var navigationBar: some View {
        HStack(spacing: 16) {
            BackButton()
            StudyProgressBar(
                progress: viewModel.wordStudyState.currentProgressRate
            )
        }
    }

    private var dialogue: some View {
        let viewModel = WordDialogueViewModel {
            self.viewModel.setIsNextButtonEnabled(true)
        }
        return WordDialogueView(viewModel: viewModel)
    }

    private var explanation: some View {
        let viewModel = WordExplanationViewModel {
            self.viewModel.setIsNextButtonEnabled(true)
        }
        return WordExplanationView(viewModel: viewModel)
    }

    private var writingWord: some View {
        let viewModel = WritingWordViewModel {
            self.viewModel.setIsNextButtonEnabled(true)
        }
        return WritingWordView(viewModel: viewModel)
    }

    private var speakingSentence: some View {
        let viewModel = SpeakingSentenceViewModel {
            self.viewModel.setIsNextButtonEnabled(true)
        }
        return SpeakingSentenceView(viewModel: viewModel)
    }

    private var writingSentence: some View {
        let viewModel = WritingSentenceViewModel {
            self.viewModel.setIsNextButtonEnabled(true)
        }
        return WritingSentenceView(viewModel: viewModel)
    }

    private var finish: some View {
        VStack(spacing: 16) {
            Image(.characterSmile)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 160)
            Text("Congratulations!")
                .font(.title2)
                .bold()
                .foregroundStyle(.greenDark)
            Text("New Stage Unlocked")
                .font(.title3)
                .bold()
                .foregroundStyle(.grayNormal)

            Spacer()

            Text("Stage 1")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.blackNormal)

            Spacer()

            Button {} label: {
                Image(systemName: "house")
                    .foregroundStyle(.blackNormal)
            }
            .buttonStyle(StudyCircleButtonStyle())
            .padding(.bottom, 24)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: 480)
        .background(StudyCardBackground())
    }

    private var nextButton: some View {
        Button("Next") {
            withAnimation {
                viewModel.nextStudyState()
            }
        }
        .buttonStyle(StudyNextButtonStyle())
        .disabled(!viewModel.isNextButtonEnabled)
    }
}

#Preview {
    WordStudyView()
}
