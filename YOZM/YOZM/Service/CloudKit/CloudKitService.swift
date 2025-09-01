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

// MARK: - Constants
private enum CloudKitConstants {
    static let containerIdentifier = "iCloud.com.company.YOZM"
    static let wordRecordType = "WordRecord"
    static let chapterRecordType = "ChapterRecord"
    static let stageRecordType = "StageRecord"
    static let dialogueRecordType = "DialogueRecord"
}

// MARK: - CloudKit Service
final class CloudKitService {
    static let shared = CloudKitService()
    
    private let container = CKContainer(identifier: CloudKitConstants.containerIdentifier)
    private let publicDatabase: CKDatabase
    
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
    
    // 공통 레코드 가져오기 로직
    private func getRecord(recordIDString: String) async throws -> CKRecord {
        let recordID = CKRecord.ID(recordName: recordIDString)
        
        do {
            let record = try await publicDatabase.record(for: recordID)
            
            guard record.recordType == CloudKitConstants.wordRecordType else {
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
            throw CloudKitError.audioURLNotFound
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

}
