//
//  StageCloudKit.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

struct StageCloudKit {
    let record: CKRecord

    func id() throws -> Int64 {
        guard let value = record[CloudKitField.id.rawValue] as? Int64 else {
            throw CloudKitError.missingField(field: CloudKitField.id.rawValue)
        }
        return value
    }

    func title() throws -> String {
        guard let value = record[CloudKitField.title.rawValue] as? String else {
            throw CloudKitError.missingField(field: CloudKitField.title.rawValue)
        }
        return value
    }

    func chapterReference() throws -> CKRecord.Reference {
        guard let value = record[CloudKitField.chapterReference.rawValue] as? CKRecord.Reference else {
            throw CloudKitError.missingField(field: CloudKitField.chapterReference.rawValue)
        }
        return value
    }

    init(id: Int64, title: String, chapterRecord: CKRecord) {
        self.record = CKRecord(recordType: CloudKitType.stageRecordType)
        self.record[CloudKitField.id.rawValue] = id as CKRecordValue
        self.record[CloudKitField.title.rawValue] = title as CKRecordValue
        self.record[CloudKitField.chapterReference.rawValue] =
            CKRecord.Reference(record: chapterRecord, action: .deleteSelf)
    }

    init(record: CKRecord) {
        self.record = record
    }
}
