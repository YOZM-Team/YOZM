//
//  WordDialogueViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Foundation

@Observable
final class WordDialogueViewModel {
    private(set) var dialogue: [Dialogue]
    let finishAction: (() -> Void)?

    init(
        word: Word = Word.sampleWord,
        finishAction: (() -> Void)? = nil
    ) {
        self.dialogue = word.sampleDialogue
        self.finishAction = finishAction
    }
}
