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
