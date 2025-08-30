//
//  Word.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import Foundation

struct Word {
    let id: UUID
    let word: String
    let meaning: String
    let sampleSentence: String
    let sampleDialogue: [DialogueSentence]
}

extension Word {
    static var sampleWord: Word {
        Word(
            id: UUID(),
            word: "느좋",
            meaning: "느낌 좋은, 어떤 대상이나 상황에 대해 긍정적인 느낌, 즉 좋다는 감정을 표현할 때 사용",
            sampleSentence: "느좋 카페 갈래?",
            sampleDialogue: [
                DialogueSentence(index: 0, speaker: .other, sentence: "야, 느좋 카페 갈래?"),
                DialogueSentence(index: 1, speaker: .me, sentence: "아니, 사람 많아서 싫어"),
                DialogueSentence(index: 2, speaker: .other, sentence: "아 왜 그냥 가자"),
            ]
        )
    }
}
