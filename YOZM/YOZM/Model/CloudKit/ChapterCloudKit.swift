//
//  ChapterCloudKit.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

final class ChapterCloudKit: CloudKitRecordWrapper {
    var id: Int64 { record["id"] as? Int64 ?? 0 }
    var title: String { record["title"] as? String ?? "" }

    init(id: Int64, title: String) {
        let ckRecord = CKRecord(recordType: "ChapterRecord")
        ckRecord["id"] = id as CKRecordValue
        ckRecord["title"] = title as CKRecordValue
        super.init(record: ckRecord)
    }
}
