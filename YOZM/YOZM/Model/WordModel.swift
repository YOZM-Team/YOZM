//
//  StudyModels.swift
//  YOZM
//
//  Created by 최희진 on 9/7/25.
//

import Foundation
import SwiftData

@Model
final class ChapterModel {
    var id: Int64 = 0
    var title: String = ""
    @Relationship(deleteRule: .cascade) var stages: [StageModel]?
    
    init(id: Int64, title: String) {
        self.id = id
        self.title = title
        self.stages = []
    }
}

@Model
final class StageModel {
    var id: Int64 = 0
    var title: String = ""
    @Relationship(inverse: \ChapterModel.stages) var chapter: ChapterModel?
    @Relationship(deleteRule: .cascade) var words: [WordModel]?
    
    init(id: Int64, title: String) {
        self.id = id
        self.title = title
        self.words = []
    }
}

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

@Model
final class DialogueModel {
    var id: Int64 = 0
    var speakerType: Int64 = 0
    var sentence: String = ""
    @Relationship(inverse: \WordModel.sampleDialogue) var word: WordModel?
    
    init(id: Int64, speakerType: Int64, sentence: String) {
        self.id = id
        self.speakerType = speakerType
        self.sentence = sentence
    }
}

extension ChapterModel {
    func toChapter() -> Chapter {
        Chapter(
            id: self.id,
            title: self.title,
            stages: (self.stages ?? []).map { $0.toStage() }
        )
    }
    
    static func from(_ chapter: Chapter) -> ChapterModel {
        let model = ChapterModel(id: chapter.id, title: chapter.title)
        return model
    }
}

extension StageModel {
    func toStage() -> Stage {
        Stage(
            id: self.id,
            title: self.title,
            words: (self.words ?? []).map { $0.toWord() }
        )
    }
    
    static func from(_ stage: Stage) -> StageModel {
        let model = StageModel(id: stage.id, title: stage.title)
        return model
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

extension DialogueModel {
    func toDialogue() -> Dialogue {
        Dialogue(
            id: self.id,
            speakerType: self.speakerType,
            sentence: self.sentence
        )
    }
    
    static func from(_ dialogue: Dialogue) -> DialogueModel {
        DialogueModel(
            id: dialogue.id,
            speakerType: dialogue.speakerType,
            sentence: dialogue.sentence
        )
    }
}
