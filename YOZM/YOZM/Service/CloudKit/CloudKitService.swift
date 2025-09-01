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
        case .missingField(field: let field):
            return "필드 \(field)가 누락되었습니다"
        case .invalidData(let message):
            return "잘못된 데이터: \(message)"
        }
    }
}

final class CloudKitService {
    private let uploader = CloudKitUploaderService()
    private let fetcher = CloudKitFetcherService()
    private let audio = CloudKitAudioService()
    
    static let shared = CloudKitService()
    private init() {}
    
    // MARK: - Data Management
    func upload() async throws {
        let chapters = try loadChaptersFromJSON()
        try await uploader.upload(chapters: chapters)
    }
    
    func fetchChapter(by id: Int64) async throws -> Chapter {
        return try await fetcher.fetchChapter(by: id)
    }
    
    private func loadChaptersFromJSON() throws -> [Chapter] {
        guard let url = Bundle.main.url(forResource: "exampleData", withExtension: "json") else {
            throw CloudKitError.invalidData("exampleData.json 파일을 찾을 수 없습니다")
        }
        
        let data = try Data(contentsOf: url)
        let chapterData = try JSONDecoder().decode(ChapterData.self, from: data)
        
        return chapterData.chapters
    }
    
    // MARK: - Audio Management
    
    /// Word ID로 word 오디오 URL 가져오기
    func fetchWordAudioURL(wordId: Int64) async throws -> URL {
        return try await audio.fetchWordAudioURL(wordId: wordId)
    }
    
    /// Word ID로 sentence 오디오 URL 가져오기
    func fetchSentenceAudioURL(wordId: Int64) async throws -> URL {
        return try await audio.fetchSentenceAudioURL(wordId: wordId)
    }
    
    /// Word ID로 dialogue 오디오 URL 배열 가져오기
    func fetchDialogueAudioURLs(wordId: Int64) async throws -> [URL] {
        return try await audio.fetchDialogueAudioURLs(wordId: wordId)
    }
    
    /// Dialogue ID로 특정 dialogue 오디오 URL 가져오기
    func fetchDialogueAudioURL(dialogueId: Int64) async throws -> URL {
        return try await audio.fetchDialogueAudioURL(dialogueId: dialogueId)
    }
}

