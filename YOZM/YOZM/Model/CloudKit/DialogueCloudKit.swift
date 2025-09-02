//
//  DialogueCloudKit.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

struct DialogueCloudKit {
    let record: CKRecord

    func id() throws -> Int64 {
        guard let value = record[CloudKitField.id.rawValue] as? Int64 else {
            throw CloudKitError.missingField(field: CloudKitField.id.rawValue)
        }
        return value
    }

    func sentence() throws -> String {
        guard let value = record[CloudKitField.sentence.rawValue] as? String else {
            throw CloudKitError.missingField(field: CloudKitField.sentence.rawValue)
        }
        return value
    }

    func speakerType() throws -> Int64 {
        guard let value = record[CloudKitField.speakerType.rawValue] as? Int64 else {
            throw CloudKitError.missingField(field: CloudKitField.speakerType.rawValue)
        }
        return value
    }

    func wordReference() throws -> CKRecord.Reference {
        guard let value = record[CloudKitField.wordReference.rawValue] as? CKRecord.Reference else {
            throw CloudKitError.missingField(field: CloudKitField.wordReference.rawValue)
        }
        return value
    }

    init(id: Int64, sentence: String, speakerType: Int64, wordRecord: CKRecord) {
        self.record = CKRecord(recordType: CloudKitType.dialogueRecordType)
        self.record[CloudKitField.id.rawValue] = id as CKRecordValue
        self.record[CloudKitField.sentence.rawValue] = sentence as CKRecordValue
        self.record[CloudKitField.speakerType.rawValue] = speakerType as CKRecordValue
        self.record[CloudKitField.wordReference.rawValue] =
            CKRecord.Reference(record: wordRecord, action: .deleteSelf)
    }

    init(record: CKRecord) {
        self.record = record
    }
}
