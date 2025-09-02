//
//  WordRecord.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

struct WordRecord {
    let id: Int64
    let word: String
    let meaning: String
    let pronunciation: String
    let sampleSentence: String
    let sampleDialogue: [String]
    let stageReference: CKRecord.Reference

    init(id: Int64, word: String, meaning: String, pronunciation: String,
         sampleSentence: String, sampleDialogue: [String], stageRecord: CKRecord) {
        self.id = id
        self.word = word
        self.meaning = meaning
        self.pronunciation = pronunciation
        self.sampleSentence = sampleSentence
        self.sampleDialogue = sampleDialogue
        self.stageReference = CKRecord.Reference(record: stageRecord, action: .deleteSelf)
    }
}

extension WordRecord{
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: CloudKitType.wordRecordType)
        record[CloudKitField.id.rawValue] = id as CKRecordValue
        record[CloudKitField.word.rawValue] = word as CKRecordValue
        record[CloudKitField.meaning.rawValue] = meaning as CKRecordValue
        record[CloudKitField.pronunciation.rawValue] = pronunciation as CKRecordValue
        record[CloudKitField.sampleSentence.rawValue] = sampleSentence as CKRecordValue
        record[CloudKitField.sampleDialogue.rawValue] = sampleDialogue as CKRecordValue
        record[CloudKitField.stageReference.rawValue] = stageReference
        return record
    }
}
