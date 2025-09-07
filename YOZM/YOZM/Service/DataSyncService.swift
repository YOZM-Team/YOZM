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
    
    var errorDescription: String? {
        switch self {
        case .cloudKitFetchFailed(let error):
            return "CloudKit 데이터 가져오기 실패: \(error.localizedDescription)"
        case .subscriptionCreationFailed(let error):
            return "CloudKit 구독 생성 실패: \(error.localizedDescription)"
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
    
    func handleCloudKitNotification() async {
        await performFullSync()
    }
    
    private func performFullSync() async {
        syncState = .syncing
        
        do {
            let chapters = try await cloudKitService.fetchAllChapters()
            try await saveChaptersToSwiftData(chapters)
            
            let now = Date()
            syncState = .success(lastSyncDate: now)
            
        } catch {
            syncState = .failed(.cloudKitFetchFailed(error))
        }
    }
    
    private func saveChaptersToSwiftData(_ chapters: [Chapter]) async throws {
        try swiftDataService.clearAllData()
        
        for chapter in chapters {
            try swiftDataService.saveChapter(chapter)
        }
    }
}
