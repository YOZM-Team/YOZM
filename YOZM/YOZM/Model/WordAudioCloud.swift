//
//  WordAudioCloud.swift
//  YOZM
//
//  Created by 최희진 on 8/26/25.
//

import CloudKit

struct WordAudioCloud {
    let recordID: CKRecord.ID
    let id: String
    let word: String
    let meaning: String
    let sampleSentence: String
    let sampleDialogue: [String]
    
    init(from record: CKRecord) {
        self.recordID = record.recordID
        self.id = record["id"] as? String ?? ""
        self.word = record["word"] as? String ?? ""
        self.meaning = record["meaning"] as? String ?? ""
        self.sampleSentence = record["sampleSentence"] as? String ?? ""
        
        // 시나리오 텍스트들 추출
        var DialogueArray: [String] = []
        var scenarioIndex = 1
        while let sampleDialogue = record["sampleSentence\(scenarioIndex)"] as? String {
            DialogueArray.append(sampleDialogue)
            scenarioIndex += 1
        }
        self.sampleDialogue = DialogueArray
    }
}
