//
//  StageRecord.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

struct StageRecord {
    let id: Int64
    let title: String
    let chapterReference: CKRecord.Reference

    init(id: Int64, title: String, chapterRecord: CKRecord) {
        self.id = id
        self.title = title
        self.chapterReference = CKRecord.Reference(record: chapterRecord, action: .deleteSelf)
    }
}

extension StageRecord{
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: CloudKitType.stageRecordType)
        record[CloudKitField.id.rawValue] = id as CKRecordValue
        record[CloudKitField.title.rawValue] = title as CKRecordValue
        record[CloudKitField.chapterReference.rawValue] = chapterReference
        return record
    }
}
