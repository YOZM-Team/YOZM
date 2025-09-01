//
//  WordCloudKit.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

final class WordCloudKit {
    let record: CKRecord

    func id() throws -> Int64 {
        guard let value = record[CloudKitField.id.rawValue] as? Int64 else {
            throw CloudKitError.missingField(field: CloudKitField.id.rawValue)
        }
        return value
    }

    func word() throws -> String {
        guard let value = record[CloudKitField.word.rawValue] as? String else {
            throw CloudKitError.missingField(field: CloudKitField.word.rawValue)
        }
        return value
    }

    func meaning() throws -> String {
        guard let value = record[CloudKitField.meaning.rawValue] as? String else {
            throw CloudKitError.missingField(field: CloudKitField.meaning.rawValue)
        }
        return value
    }

    func pronunciation() throws -> String {
        guard let value = record[CloudKitField.pronunciation.rawValue] as? String else {
            throw CloudKitError.missingField(field: CloudKitField.pronunciation.rawValue)
        }
        return value
    }

    func sampleSentence() throws -> String {
        guard let value = record[CloudKitField.sampleSentence.rawValue] as? String else {
            throw CloudKitError.missingField(field: CloudKitField.sampleSentence.rawValue)
        }
        return value
    }

    func sampleDialogue() throws -> [String] {
        guard let value = record[CloudKitField.sampleDialogue.rawValue] as? [String] else {
            throw CloudKitError.missingField(field: CloudKitField.sampleDialogue.rawValue)
        }
        return value
    }

    func stageReference() throws -> CKRecord.Reference {
        guard let value = record[CloudKitField.stageReference.rawValue] as? CKRecord.Reference else {
            throw CloudKitError.missingField(field: CloudKitField.stageReference.rawValue)
        }
        return value
    }

    init(id: Int64, word: String, meaning: String, pronunciation: String,
         sampleSentence: String, sampleDialogue: [String], stageRecord: CKRecord) {

        self.record = CKRecord(recordType: CloudKitType.wordRecordType)
        self.record[CloudKitField.id.rawValue] = id as CKRecordValue
        self.record[CloudKitField.word.rawValue] = word as CKRecordValue
        self.record[CloudKitField.meaning.rawValue] = meaning as CKRecordValue
        self.record[CloudKitField.pronunciation.rawValue] = pronunciation as CKRecordValue
        self.record[CloudKitField.sampleSentence.rawValue] = sampleSentence as CKRecordValue
        self.record[CloudKitField.sampleDialogue.rawValue] = sampleDialogue as CKRecordValue
        self.record[CloudKitField.stageReference.rawValue] = CKRecord.Reference(record: stageRecord, action: .deleteSelf)
    }

    init(record: CKRecord) {
        self.record = record
    }
}
