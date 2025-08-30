//
//  WordDialogueViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Foundation

@Observable
final class WordDialogueViewModel {
    private(set) var dialogue: [DialogueSentence]
    let finishAction: (() -> Void)?

    init(
        dialogue: [DialogueSentence] = Word.sampleWord.sampleDialogue,
        finishAction: (() -> Void)? = nil
    ) {
        self.dialogue = dialogue
        self.finishAction = finishAction
    }
}
