//
//  WordAudioRecord.swift
//  YOZM
//
//  Created by 최희진 on 8/26/25.
//

import CloudKit

struct WordAudioRecord {
    let recordID: String
    let id: Int64
    let word: String
    let meaning: String
    let sampleSentence: String
    let sampleDialogue: [String]
    
    init(from record: CKRecord) throws {
        recordID = record.recordID.recordName
        id = try record.get(.id)
        word = try record.get(.word)
        meaning = try record.get(.meaning)
        sampleSentence = try record.get(.sampleSentence)
        sampleDialogue = try record.get(.sampleDialogue)
    }
}
extension CKRecord {
    func get<T>(_ field: CloudKitField) throws -> T {
        // 1단계: 필드 존재 여부 확인
        guard self[field.rawValue] != nil else {
            throw CloudKitError.missingField(field: field.rawValue)
        }
        
        // 2단계: 타입 확인
        guard let value = self[field.rawValue] as? T else {
            let typeName = String(describing: T.self)
            throw CloudKitError.invalidFieldType(field: field.rawValue, expected: typeName)
        }
        
        return value
    }
}
