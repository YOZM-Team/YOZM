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
    // 공통
    case id = "id"
    // ChapterCloudKit
    case title = "title"
    // StageCloudKit
    case chapterReference = "chapterReference"
    // DialogueCloudKit
    case sentence = "sentence"
    case speakerType = "speakerType"
    case wordReference = "wordReference"
    // WordCloudKit
    case word = "word"
    case meaning = "meaning"
    case pronunciation = "pronunciation"
    case sampleSentence = "sampleSentence"
    case sampleDialogue = "sampleDialogue"
    case stageReference = "stageReference"
}

enum CloudKitType {
    static let wordRecordType = "WordRecord"
    static let chapterRecordType = "ChapterRecord"
    static let stageRecordType = "StageRecord"
    static let dialogueRecordType = "DialogueRecord"
}
