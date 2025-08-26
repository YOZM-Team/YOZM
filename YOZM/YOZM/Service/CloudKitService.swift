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
    
    /// 단일 음성 URL 가져오기 (word, sentence용)
    func fetchAudioData(recordIDString: String, audioType: AudioType) async throws -> URL {
        let record = try await getRecord(recordIDString: recordIDString)
        
        guard let audioAsset = record[audioType.fieldName] as? CKAsset else {
            throw CloudKitError.audioDataNotFound
        }
        
        return try fetchAudioFileURL(audioAsset: audioAsset)
    }
    
    /// 다중 음성 URL 가져오기 (dialogue용)
    func fetchAudioDatas(recordIDString: String) async throws -> [URL] {
        let record = try await getRecord(recordIDString: recordIDString)
        
        guard let audioAssets = record[AudioType.dialogue.fieldName] as? [CKAsset] else {
            throw CloudKitError.audioDataNotFound
        }
        
        return try fetchAudioFileURLs(audioAssets: audioAssets)
    }
    
    
    /// 특정 recordID의 데이터 조회
    func fetchAndPrintRecord(recordIDString: String) async throws -> WordAudioRecord {
        let recordID = createRecordID(from: recordIDString)
        
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
    
    // 공통 레코드 가져오기 로직
    private func getRecord(recordIDString: String) async throws -> CKRecord {
        let recordID = createRecordID(from: recordIDString)
        
        do {
            let record = try await publicDatabase.record(for: recordID)
            
            guard record.recordType == cloudRecordType else {
                throw CloudKitError.invalidRecordType
            }
            
            return record
            
        } catch let error as CKError {
            if error.code == .unknownItem {
                throw CloudKitError.recordNotFound
            } else {
                throw CloudKitError.networkError(error.localizedDescription)
            }
        }
    }
    
    /// 단일 CKAsset에서 fileURL 추출
    private func fetchAudioFileURL(audioAsset: CKAsset) throws -> URL {
        guard let fileURL = audioAsset.fileURL else {
            throw CloudKitError.audioDataNotFound
        }
        return fileURL
    }
    
    /// CKAsset 배열에서 모든 fileURL 추출
    private func fetchAudioFileURLs(audioAssets: [CKAsset]) throws -> [URL] {
        var urls: [URL] = []
        
        for audioAsset in audioAssets {
            if let fileURL = audioAsset.fileURL {
                urls.append(fileURL)
            }
        }
        
        guard !urls.isEmpty else {
            throw CloudKitError.audioDataNotFound
        }
        
        return urls
    }
    
    private func createRecordID(from recordName: String) -> CKRecord.ID {
        return CKRecord.ID(recordName: recordName)
    }
}
