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
    case invalidRecordType
    case networkError(String)
    
    var errorDescription: String {
        switch self {
        case .recordNotFound:
            return "레코드를 찾을 수 없습니다"
        case .audioDataNotFound:
            return "음성 데이터를 찾을 수 없습니다"
        case .invalidRecordType:
            return "잘못된 레코드 타입입니다"
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        }
    }
}

// MARK: - CloudKit Service
final class CloudKitService {
    static let shared = CloudKitService()
    
    private let container = CKContainer(identifier: "iCloud.com.company.YOZM")
    private let publicDatabase: CKDatabase
    private let cloudRecordType = "WordAudio"
    
    private init() {
        self.publicDatabase = container.publicCloudDatabase
    }
    
    /// 특정 레코드 ID로 음성 데이터만 가져오기
    func fetchAudioData(recordID: CKRecord.ID, audioType: AudioType) async throws -> CKAsset {
        do {
            let record = try await publicDatabase.record(for: recordID)
            
            guard record.recordType == cloudRecordType else {
                throw CloudKitError.invalidRecordType
            }
            
            guard let audioAsset = record[audioType.fieldName] as? CKAsset else {
                throw CloudKitError.audioDataNotFound
            }
            
            return audioAsset
        } catch let error as CKError {
            if error.code == .unknownItem {
                throw CloudKitError.recordNotFound
            } else {
                throw CloudKitError.networkError(error.localizedDescription)
            }
        }
    }
    
    /// 특정 recordID의 데이터를 가져와서 출력
    func fetchAndPrintRecord(recordID: CKRecord.ID) async throws -> WordAudioRecord {
        do {
            let record = try await publicDatabase.record(for: recordID)
            
            guard record.recordType == cloudRecordType else {
                throw CloudKitError.invalidRecordType
            }
            
            let wordAudio = WordAudioRecord(from: record)
            
            print("=== CloudKit Record Data ===")
            print("Record ID: \(wordAudio.recordID)")
            print("ID: \(wordAudio.id)")
            print("Word: \(wordAudio.word)")
            print("Meaning: \(wordAudio.meaning)")
            print("Sample Sentence: \(wordAudio.sampleSentence)")
            print("Sample Dialogues: \(wordAudio.sampleDialogue)")
            print("============================")
            
            return wordAudio
        } catch let error as CKError {
            if error.code == .unknownItem {
                throw CloudKitError.recordNotFound
            } else {
                throw CloudKitError.networkError(error.localizedDescription)
            }
        }
    }
}
