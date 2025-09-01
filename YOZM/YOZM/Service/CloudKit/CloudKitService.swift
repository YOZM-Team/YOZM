//
//  CloudKitService.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import CloudKit

/// CloudKit 서비스 에러
enum CloudKitError: Error, LocalizedError {
    case recordNotFound
    case audioDataNotFound
    case audioURLNotFound
    case invalidRecordType
    case networkError(String)
    case invalidFieldType(field: String, expected: String)
    case missingField(field: String)
    case invalidData(String)
    
    var errorDescription: String {
        switch self {
        case .recordNotFound:
            return "레코드를 찾을 수 없습니다"
        case .audioDataNotFound:
            return "음성 데이터를 찾을 수 없습니다"
        case .audioURLNotFound:
            return "음성 파일 URL을 찾을 수 없습니다"
        case .invalidRecordType:
            return "잘못된 레코드 타입입니다"
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .invalidFieldType(field: let field, expected: let expected):
            return "필드 \(field)의 타입이 \(expected)이 아닙니다"
        case .missingField(field: let field):
            return "필드 \(field)가 누락되었습니다"
        case .invalidData(let message):
            return "잘못된 데이터: \(message)"
        }
    }
}

// MARK: - JSON 데이터 구조
struct ChapterData: Codable {
    let chapters: [Chapter]
}

// MARK: - CloudKit 래퍼 클래스들
class ChapterCloudKit {
    let record: CKRecord
    
    var id: Int64 {
        return record["id"] as? Int64 ?? 0
    }
    
    var title: String {
        return record["title"] as? String ?? ""
    }
    
    init(id: Int64, title: String) {
        self.record = CKRecord(recordType: "ChapterRecord")
        self.record["id"] = id as CKRecordValue
        self.record["title"] = title as CKRecordValue
    }
    
    init(record: CKRecord) {
        self.record = record
    }
}

class StageCloudKit {
    let record: CKRecord
    
    var id: Int64 {
        return record["id"] as? Int64 ?? 0
    }
    
    var title: String {
        return record["title"] as? String ?? ""
    }
    
    var chapterReference: CKRecord.Reference? {
        return record["chapterReference"] as? CKRecord.Reference
    }
    
    init(id: Int64, title: String, chapterRecord: CKRecord) {
        self.record = CKRecord(recordType: "StageRecord")
        self.record["id"] = id as CKRecordValue
        self.record["title"] = title as CKRecordValue
        self.record["chapterReference"] = CKRecord.Reference(record: chapterRecord, action: .deleteSelf)
    }
    
    init(record: CKRecord) {
        self.record = record
    }
}

class WordCloudKit {
    let record: CKRecord
    
    var id: Int64 {
        return record["id"] as? Int64 ?? 0
    }
    
    var word: String {
        return record["word"] as? String ?? ""
    }
    
    var meaning: String {
        return record["meaning"] as? String ?? ""
    }
    
    var pronunciation: String {
        return record["pronunciation"] as? String ?? ""
    }
    
    var sampleSentence: String {
        return record["sampleSentence"] as? String ?? ""
    }
    
    var sampleDialogue: [String] {
        return record["sampleDialogue"] as? [String] ?? []
    }
    
    var stageReference: CKRecord.Reference? {
        return record["stageReference"] as? CKRecord.Reference
    }
    
    init(id: Int64, word: String, meaning: String, pronunciation: String,
         sampleSentence: String, sampleDialogue: [String], stageRecord: CKRecord) {
        
        self.record = CKRecord(recordType: "WordRecord")
        self.record["id"] = id as CKRecordValue
        self.record["word"] = word as CKRecordValue
        self.record["meaning"] = meaning as CKRecordValue
        self.record["pronunciation"] = pronunciation as CKRecordValue
        self.record["sampleSentence"] = sampleSentence as CKRecordValue
        self.record["sampleDialogue"] = sampleDialogue as CKRecordValue
        self.record["stageReference"] = CKRecord.Reference(record: stageRecord, action: .deleteSelf)
    }
    
    init(record: CKRecord) {
        self.record = record
    }
}

class DialogueCloudKit {
    let record: CKRecord
    
    var id: Int64 {
        return record["id"] as? Int64 ?? 0
    }
    
    var sentence: String {
        return record["sentence"] as? String ?? ""
    }
    
    var speakerType: Int64 {
        return record["speakerType"] as? Int64 ?? 0
    }
    
    var wordReference: CKRecord.Reference? {
        return record["wordReference"] as? CKRecord.Reference
    }
    
    init(id: Int64, sentence: String, speakerType: Int64, wordRecord: CKRecord) {
        self.record = CKRecord(recordType: "DialogueRecord")
        self.record["id"] = id as CKRecordValue
        self.record["sentence"] = sentence as CKRecordValue
        self.record["speakerType"] = speakerType as CKRecordValue
        self.record["wordReference"] = CKRecord.Reference(record: wordRecord, action: .deleteSelf)
    }
    
    init(record: CKRecord) {
        self.record = record
    }
}

