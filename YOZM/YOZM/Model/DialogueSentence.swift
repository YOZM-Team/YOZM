//
//  DialogueSentence.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

enum DialogueSentenceSpeaker {
    case me
    case other
}

struct DialogueSentence {
    let index: Int
    let speaker: DialogueSentenceSpeaker
    let sentence: String
}
