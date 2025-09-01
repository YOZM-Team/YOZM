//
//  Untitled.swift
//  YOZM
//
//  Created by 최희진 on 8/26/25.
//

enum AudioType {
    case word      // 단어 발음
    case sentence  // 예문 발음
    case dialogue  // 시나리오 발음
    
    var fieldName: String {
        switch self {
        case .word:
            return "wordAudio"
        case .sentence:
            return "sentenceAudio"
        case .dialogue:
            return "dialogueAudio"
        }
    }
}

enum CloudKitField: String, CaseIterable {
    case id = "id"
    case word = "word"
    case meaning = "meaning"
    case sampleSentence = "sampleSentence"
    case sampleDialogue = "sampleDialogue"
}

enum CloudKitConstants {
    static let containerIdentifier = "iCloud.com.company.YOZM"
    static let wordRecordType = "WordRecord"
    static let chapterRecordType = "ChapterRecord"
    static let stageRecordType = "StageRecord"
    static let dialogueRecordType = "DialogueRecord"
}
