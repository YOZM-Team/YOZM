//
//  CloudKitAudioService.swift
//  YOZM
//
//  Created by 최희진 on 9/1/25.
//

import CloudKit

final class CloudKitAudioService {
    private let container = CKContainer(identifier: CloudKitConstants.containerIdentifier)
    private let publicDatabase: CKDatabase
    
    init() {
        self.publicDatabase = container.publicCloudDatabase
    }
    
    /// Word ID로 word asset URL 가져오기
    func fetchWordAudioURL(wordId: Int64) async throws -> URL {
        let wordRecord = try await fetchWordRecord(by: wordId)
        return try extractAudioURL(from: wordRecord, fieldName: AudioType.word.fieldName)
    }
    
    /// Word ID로 sentence asset URL 가져오기
    func fetchSentenceAudioURL(wordId: Int64) async throws -> URL {
        let wordRecord = try await fetchWordRecord(by: wordId)
        return try extractAudioURL(from: wordRecord, fieldName: AudioType.sentence.fieldName)
    }
    
    /// Word ID로 dialogue asset URL 배열 가져오기
    func fetchDialogueAudioURLs(wordId: Int64) async throws -> [URL] {
        let wordRecord = try await fetchWordRecord(by: wordId)
        return try extractAudioURLs(from: wordRecord, fieldName: AudioType.dialogue.fieldName)
    }
    
    /// Dialogue ID로 특정 dialogue asset URL 가져오기
    func fetchDialogueAudioURL(dialogueId: Int64) async throws -> URL {
        let dialogueQuery = CKQuery(
            recordType: CloudKitConstants.dialogueRecordType,
            predicate: NSPredicate(format: "id == %lld", dialogueId)
        )
        
        let (results, _) = try await publicDatabase.records(matching: dialogueQuery)
        
        guard let (_, firstResult) = results.first,
              case .success(let dialogueRecord) = firstResult else {
            throw CloudKitError.recordNotFound
        }
        
        return try extractAudioURL(from: dialogueRecord, fieldName: "dialogueAudio")
    }
    
    private func fetchWordRecord(by wordId: Int64) async throws -> CKRecord {
        let wordQuery = CKQuery(
            recordType: CloudKitConstants.wordRecordType,
            predicate: NSPredicate(format: "id == %lld", wordId)
        )
        
        let (results, _) = try await publicDatabase.records(matching: wordQuery)
        
        guard let (_, firstResult) = results.first,
              case .success(let wordRecord) = firstResult else {
            throw CloudKitError.recordNotFound
        }
        
        return wordRecord
    }
    
    /// 단일 CKAsset에서 fileURL 추출
    private func extractAudioURL(from record: CKRecord, fieldName: String) throws -> URL {
        guard let audioAsset = record[fieldName] as? CKAsset,
              let fileURL = audioAsset.fileURL else {
            throw CloudKitError.audioURLNotFound
        }
        
        return fileURL
    }
    
    /// 다중 CKAsset에서 fileURL 배열 추출
    private func extractAudioURLs(from record: CKRecord, fieldName: String) throws -> [URL] {
        guard let audioAssets = record[fieldName] as? [CKAsset] else {
            throw CloudKitError.audioDataNotFound
        }
        
        return audioAssets.compactMap { $0.fileURL }
    }
}
