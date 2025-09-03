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
        dialogue: [Dialogue] = Word.sampleWord.sampleDialogue,
        finishAction: (() -> Void)? = nil
    ) {
        self.dialogue = dialogue
        self.finishAction = finishAction
    }
}
