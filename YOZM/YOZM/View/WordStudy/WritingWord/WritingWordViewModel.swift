//
//  WritingWordViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Foundation

@Observable
final class WritingWordViewModel {
    private(set) var word: Word
    private(set) var text: String
    var isCorrect: Bool {
        text == word.word
    }

    private let finishAction: (() -> Void)?

    init(
        word: Word = Word.sampleWord,
        finishAction: (() -> Void)? = nil
    ) {
        self.word = word
        self.text = ""
        self.finishAction = finishAction
    }

    func setText(_ text: String) {
        self.text = text
        if isCorrect {
            finishAction?()
        }
    }
}
