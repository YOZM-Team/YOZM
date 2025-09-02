//
//  DialogueCloudKit.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

struct DialogueRecord {
    let id: Int64
    let sentence: String
    let speakerType: Int64
    let wordReference: CKRecord.Reference

    init(id: Int64, sentence: String, speakerType: Int64, wordRecord: CKRecord) {
        self.id = id
        self.sentence = sentence
        self.speakerType = speakerType
        self.wordReference = CKRecord.Reference(record: wordRecord, action: .deleteSelf)
    }
}

extension DialogueRecord{
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: CloudKitType.dialogueRecordType)
        record[CloudKitField.id.rawValue] = id as CKRecordValue
        record[CloudKitField.sentence.rawValue] = sentence as CKRecordValue
        record[CloudKitField.speakerType.rawValue] = speakerType as CKRecordValue
        record[CloudKitField.wordReference.rawValue] = wordReference
        return record
    }
}
