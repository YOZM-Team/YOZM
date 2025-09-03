//
//  WordExplanationViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Foundation

@Observable
final class WordExplanationViewModel {
    private(set) var word: Word
    let finishAction: (() -> Void)?

    init(
        word: Word = Word.sampleWord,
        finishAction: (() -> Void)? = nil
    ) {
        self.word = word
        self.finishAction = finishAction
    }
}
