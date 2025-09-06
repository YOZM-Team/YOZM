//
//  SpeakingSentenceView.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct SpeakingSentenceView: View {
    @State private var viewModel: SpeakingSentenceViewModel

    init(viewModel: SpeakingSentenceViewModel = SpeakingSentenceViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            Text("Listen & Repeat")
                .font(.title)
                .bold()
                .foregroundStyle(.blackNormal)

            HStack {
                Text(viewModel.word.sampleSentence)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.blackNormal)
                    .frame(maxWidth: .infinity)

                audioPlayButton
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .strokeBorder(.stroke)
            }

            Spacer()

            VStack(spacing: 64) {
                transcribeButton

                StudyTextField(
                    text: .constant(viewModel.transcription ?? ""),
                    correctText: viewModel.word.sampleSentence,
                    isCorrect: viewModel.isCorrect
                )
                .disabled(true)
                .overlay {
                    if viewModel.isCorrect {
                        Text(viewModel.word.sampleSentence)
                            .foregroundStyle(.blackNormal)
                    }
                }
                .onChange(of: viewModel.transcription) { _, _ in
                    viewModel.scorePronunciation()
                }
            }
        }
        .padding(.vertical, Spacing.lg)
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: 480)
        .background(StudyCardBackground())
    }

    @ViewBuilder
    private var audioPlayButton: some View {
        if viewModel.isPlaying {
            Button {
                viewModel.stopAudio()
            } label: {
                Image(systemName: "stop.circle")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.greenDark)
            }
        } else {
            Button {
                viewModel.playAudio()
            } label: {
                Image(systemName: "play.circle")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.greenDark)
            }
        }
    }

    @ViewBuilder
    private var transcribeButton: some View {
        if viewModel.isSpeaking {
            Button {
                viewModel.stopSpeaking()
            } label: {
                Image(systemName: "ellipsis")
            }
            .buttonStyle(StudyCircleButtonStyle())
        } else {
            Button {
                viewModel.startSpeaking()
            } label: {
                Image(systemName: "mic")
            }
            .buttonStyle(StudyCircleButtonStyle())
        }
    }
}

#Preview {
    SpeakingSentenceView()
}
