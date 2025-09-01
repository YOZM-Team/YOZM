//
//  StageCloudKit.swift
//  YOZM
//
//  Created by 최희진 on 9/2/25.
//

import CloudKit

final class StageCloudKit: CloudKitRecordWrapper {
    var id: Int64 { record["id"] as? Int64 ?? 0 }
    var title: String { record["title"] as? String ?? "" }
    var chapterReference: CKRecord.Reference? { record["chapterReference"] as? CKRecord.Reference }

    init(id: Int64, title: String, chapterRecord: CKRecord) {
        let ckRecord = CKRecord(recordType: "StageRecord")
        ckRecord["id"] = id as CKRecordValue
        ckRecord["title"] = title as CKRecordValue
        ckRecord["chapterReference"] = CKRecord.Reference(record: chapterRecord, action: .deleteSelf)
        super.init(record: ckRecord)
    }
}
