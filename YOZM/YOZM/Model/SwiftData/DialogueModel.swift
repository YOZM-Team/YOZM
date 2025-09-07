//
//  DialogueModel.swift
//  YOZM
//
//  Created by 최희진 on 9/7/25.
//

import Foundation
import SwiftData

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
