//
//  WordDialogueView.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import SwiftUI

struct WordDialogueView: View {
    @State private var viewModel: WordDialogueViewModel
    @State private var displayedCount: Int = 0
    @State private var hasAnimated: Bool = false

    init(viewModel: WordDialogueViewModel = WordDialogueViewModel()) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            partnerProfile
            chat
        }
    }

    private var partnerProfile: some View {
        HStack {
            circleImage(.sejong)
            VStack(alignment: .leading) {
                Text("세종")
                    .font(.headline)
                    .foregroundStyle(.blackNormal)
                Text("Online")
                    .font(.caption)
                    .foregroundStyle(.grayNormal)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var chat: some View {
        VStack {
            ForEach(viewModel.dialogue.prefix(displayedCount), id: \.index) {
                sentence in
                dialogueRow(sentence)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 480, alignment: .top)
        .background(StudyCardBackground())
        .task {
            guard !hasAnimated else { return }
            hasAnimated = true
            displayedCount = 0
            let total = viewModel.dialogue.count
            for i in 1 ... total {
                try? await Task.sleep(for: .seconds(1))
                displayedCount = i
            }
            viewModel.finishAction?()
        }
    }

    @ViewBuilder
    private func dialogueRow(_ sentence: DialogueSentence) -> some View {
        if sentence.speaker == .me {
            HStack {
                Spacer()

                Text(sentence.sentence)
                    .foregroundStyle(.blackNormal)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.tertiaryNormal)
                    }
            }
        } else if sentence.speaker == .other {
            HStack {
                circleImage(.sejong)
                Text(sentence.sentence)
                    .foregroundStyle(.blackNormal)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .strokeBorder(.stroke)
                    }

                Spacer()
            }
        }
    }

    private func circleImage(_ image: ImageResource) -> some View {
        Image(image)
            .frame(width: 34, height: 34)
            .overlay {
                Circle()
                    .fill(.clear)
                    .stroke(.blackNormal, lineWidth: 1)
            }
            .clipShape(Circle())
    }
}

#Preview {
    WordDialogueView()
}
