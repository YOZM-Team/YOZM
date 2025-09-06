//
//  WritingSentenceViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Foundation

@Observable
final class WritingSentenceViewModel {
    private(set) var word: Word
    private(set) var isShowingHint: Bool
    private(set) var isPlaying: Bool
    private(set) var text: String
    var isCorrect: Bool {
        text == word.sampleSentence
    }

    private let finishAction: (() -> Void)?

    init(word: Word = Word.sampleWord, finishAction: (() -> Void)? = nil) {
        self.word = word
        self.isShowingHint = false
        self.isPlaying = false
        self.text = ""

        self.finishAction = finishAction
    }

    func setIsShowingHint(_ isShowingHint: Bool) {
        self.isShowingHint = isShowingHint
    }

    func playAudio() {
        // TODO: Play audio
        isPlaying = true
    }

    func stopAudio() {
        // TODO: Stop audio
        isPlaying = false
    }

    func setText(_ text: String) {
        self.text = text

        if isCorrect {
            finishAction?()
        }
    }
}
