//
//  WritingSentenceView.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct WritingSentenceView: View {
    @State private var viewModel: WritingSentenceViewModel

    init(viewModel: WritingSentenceViewModel = WritingSentenceViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Text("Test Sentence")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.blackNormal)

                hint
            }

            Spacer()

            audioPlayButton

            Spacer()

            VStack(spacing: 32) {
                Text("Type the sentence")
                    .font(.callout)
                    .bold()

                StudyTextField(
                    text: Binding(
                        get: {
                            viewModel.text
                        },
                        set: {
                            viewModel.setText($0)
                        }
                    ),
                    correctText: viewModel.word.sampleSentence,
                    isCorrect: viewModel.isCorrect
                )
            }
        }
        .onAppear{
            Task {
                await viewModel.loadAudio()
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: 480)
        .background(StudyCardBackground())
    }

    @ViewBuilder
    private var hint: some View {
        HStack {
            Text(viewModel.word.sampleSentence)
                .font(.title2)
                .bold()
                .foregroundStyle(.blackNormal)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .overlay {
            if viewModel.isShowingHint == false {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.secondaryNormal)
                    .strokeBorder(.stroke)
                    .overlay {
                        Text("Hint")
                            .font(.title2)
                            .bold()
                    }
                    .onTapGesture {
                        viewModel.setIsShowingHint(true)
                    }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .strokeBorder(.stroke)
        }
    }

    @ViewBuilder
    private var audioPlayButton: some View {
        if viewModel.isPlaying {
            Button {
                viewModel.stopAudio()
            } label: {
                Image(systemName: "stop")
            }
            .buttonStyle(StudyCircleButtonStyle())
        } else {
            Button {
                viewModel.playAudio()
            } label: {
                Image(systemName: "play")
            }
            .buttonStyle(StudyCircleButtonStyle())
        }
    }
}

#Preview {
    WritingSentenceView()
}
