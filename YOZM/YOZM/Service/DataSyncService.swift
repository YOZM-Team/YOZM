//
//  DataSyncService.swift
//  YOZM
//
//  Created by 최희진 on 9/7/25.
//

import Foundation
import SwiftData
import CloudKit

enum DataSyncError: Error, LocalizedError {
    case cloudKitFetchFailed(Error)
    case subscriptionCreationFailed(Error)
    case swiftDataServiceError(SwiftDataServiceError)
    
    var errorDescription: String? {
        switch self {
        case .cloudKitFetchFailed(let error):
            return "CloudKit 데이터 가져오기 실패: \(error.localizedDescription)"
        case .subscriptionCreationFailed(let error):
            return "CloudKit 구독 생성 실패: \(error.localizedDescription)"
        case .swiftDataServiceError(let error):
            return error.errorDescription
        }
    }
}

enum DataSyncState {
    case idle
    case syncing
    case success(lastSyncDate: Date)
    case failed(DataSyncError)
    
    var isSyncing: Bool {
        if case .syncing = self { return true }
        return false
    }
    
    var error: DataSyncError? {
        if case .failed(let error) = self { return error }
        return nil
    }
}

@MainActor
@Observable
final class DataSyncService {
    static let shared = DataSyncService()
    
    private let cloudKitService: CloudKitService
    private let swiftDataService: SwiftDataService
    
    private(set) var syncState: DataSyncState = .idle
    
    private init() {
        self.cloudKitService = CloudKitService.shared
        self.swiftDataService = SwiftDataService.shared
    }
    
    func syncDataIfNeeded() async {
        guard !syncState.isSyncing else { return }
        
        await performFullSync()
    }
    
    func fetchChaptersFromSwiftData() async throws -> [Chapter] {
        do {
            return try swiftDataService.fetchAllChapters()
        } catch {
            syncState = .failed(.swiftDataServiceError(error as? SwiftDataServiceError ?? .fetchError(error)))
            throw DataSyncError.swiftDataServiceError(error as? SwiftDataServiceError ?? .fetchError(error))
        }
    }
    
    func fetchChapter(by id: Int64) async throws -> ChapterModel? {
        do {
            return try swiftDataService.fetchChapter(by: id)
        } catch {
            throw DataSyncError.swiftDataServiceError(error as? SwiftDataServiceError ?? .fetchError(error))
        }
    }
    
    func handleCloudKitNotification() async {
        await performFullSync()
    }
    
    func clearAllData() async throws {
        try swiftDataService.clearAllData()
    }
    
    private func shouldResync() async -> Bool {
        do {
            let chapters = try swiftDataService.fetchAllChapters()
            return chapters.isEmpty
        } catch {
            return true
        }
    }
    
    private func performFullSync() async {
        syncState = .syncing
        
        do {
            let chapters = try await cloudKitService.fetchAllChapters()
            try await saveChaptersToSwiftData(chapters)
            
            let now = Date()
            syncState = .success(lastSyncDate: now)
            
        } catch {
            let syncError: DataSyncError
            if let swiftDataError = error as? SwiftDataServiceError {
                syncError = .swiftDataServiceError(swiftDataError)
            } else {
                syncError = .cloudKitFetchFailed(error)
            }
            syncState = .failed(syncError)
        }
    }
    
    private func saveChaptersToSwiftData(_ chapters: [Chapter]) async throws {
        try await clearAllData()
        
        for chapter in chapters {
            try swiftDataService.saveChapter(chapter)
        }
    }
}
