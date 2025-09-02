//
//  ChapterRecord.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

struct ChapterRecord {
    let id: Int64
    let title: String

    init(id: Int64, title: String) {
        self.id = id
        self.title = title
    }
}

extension ChapterRecord{
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: CloudKitType.chapterRecordType)
        record[CloudKitField.id.rawValue] = id as CKRecordValue
        record[CloudKitField.title.rawValue] = title as CKRecordValue
        return record
    }
}
