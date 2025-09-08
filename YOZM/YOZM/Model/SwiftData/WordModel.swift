//
//  WordModel.swift
//  YOZM
//
//  Created by 최희진 on 9/7/25.
//

import Foundation
import SwiftData

@Model
final class WordModel {
    var id: Int64 = 0
    var word: String = ""
    var meaning: String = ""
    var pronunciation: String = ""
    var sampleSentence: String = ""
    @Relationship(inverse: \StageModel.words) var stage: StageModel?
    @Relationship(deleteRule: .cascade) var sampleDialogue: [DialogueModel]?
    
    init(id: Int64, word: String, meaning: String, pronunciation: String, sampleSentence: String) {
        self.id = id
        self.word = word
        self.meaning = meaning
        self.pronunciation = pronunciation
        self.sampleSentence = sampleSentence
        self.sampleDialogue = []
    }
}

extension WordModel {
    func toWord() -> Word {
        Word(
            id: self.id,
            word: self.word,
            meaning: self.meaning,
            pronunciation: self.pronunciation,
            sampleSentence: self.sampleSentence,
            sampleDialogue: (self.sampleDialogue ?? []).map { $0.toDialogue() }
        )
    }
    
    static func from(_ word: Word) -> WordModel {
        let model = WordModel(
            id: word.id,
            word: word.word,
            meaning: word.meaning,
            pronunciation: word.pronunciation,
            sampleSentence: word.sampleSentence
        )
        return model
    }
}
