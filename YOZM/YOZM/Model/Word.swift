//
//  Word.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import Foundation

struct Word: Codable {
    let id: Int64
    let word: String
    let meaning: String
    let pronunciation: String
    let sampleSentence: String
    let sampleDialogue: [Dialogue]
}

extension Word {
    static var sampleWord: Word {
        Word(
            id: 0,
            word: "느좋",
            meaning: "느낌 좋은, 어떤 대상이나 상황에 대해 긍정적인 느낌, 즉 좋다는 감정을 표현할 때 사용",
            pronunciation: "",
            sampleSentence: "느좋 카페 갈래?",
            sampleDialogue: [
                Dialogue(id: 0, speakerType: 0, sentence: "야, 느좋 카페 갈래?"),
                Dialogue(id: 1, speakerType: 1, sentence: "아니, 사람 많아서 싫어"),
                Dialogue(id: 2, speakerType: 0, sentence: "아 왜 그냥 가자"),
            ]
        )
    }
}
