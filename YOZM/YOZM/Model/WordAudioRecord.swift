//
//  WordAudioRecord.swift
//  YOZM
//
//  Created by 최희진 on 8/26/25.
//

import CloudKit

struct WordAudioRecord {
    let recordID: String
    let id: Int64
    let word: String
    let meaning: String
    let sampleSentence: String
    let sampleDialogue: [String]
    
    init(from record: CKRecord) {
        self.recordID = record.recordID.recordName
        self.id = record["id"] as? Int64 ?? 0
        self.word = record["word"] as? String ?? ""
        self.meaning = record["meaning"] as? String ?? ""
        self.sampleSentence = record["sampleSentence"] as? String ?? ""
        self.sampleDialogue =  record["sampleDialogue"] as? [String] ?? []
    }
}
