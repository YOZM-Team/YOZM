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
    
    var lastSyncDate: Date? {
        if case .success(let date) = self { return date }
        return nil
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
    
    private let cloudKitService = CloudKitService.shared
    private let swiftDataService = SwiftDataService.shared
    private let userDefaults = UserDefaults.standard
    private let database = CKContainer.default().publicCloudDatabase
    
    private(set) var syncState: DataSyncState = .idle
    
    private init() {
        setupCloudKitSubscriptions()
    }
    
    private struct Constants {
        static let lastSyncKey = "lastCloudKitSync"
        static let subscriptionKey = "cloudkit_subscription_created"
        static let subscriptionId = "chapter-changes-subscription"
    }
    
    func syncDataIfNeeded() async {
        guard !syncState.isSyncing else { return }
        
        let lastSyncKey = Constants.lastSyncKey
        let lastSync = userDefaults.object(forKey: lastSyncKey) as? Date
        
        if lastSync == nil {
            await performFullSync()
            userDefaults.set(Date(), forKey: lastSyncKey)
        }
    }
    
    func fetchChaptersFromSwiftData() async -> [Chapter] {
        do {
            return try await swiftDataService.fetchAllChaptersAsync()
        } catch {
            syncState = .failed(.swiftDataServiceError(error as? SwiftDataServiceError ?? .fetchError(error)))
            return []
        }
    }
    
    func fetchChapter(by id: Int64) async throws -> ChapterModel? {
        do {
            return try await swiftDataService.fetchChapterAsync(by: id)
        } catch {
            throw DataSyncError.swiftDataServiceError(error as? SwiftDataServiceError ?? .fetchError(error))
        }
    }
    
    func handleCloudKitNotification() async {
        await performFullSync()
    }
    
    func clearAllData() async throws {
        try await swiftDataService.clearAllDataAsync()
        userDefaults.removeObject(forKey: Constants.lastSyncKey)
    }
    
    private func shouldResync() async -> Bool {
        do {
            let chapters = try await swiftDataService.fetchAllChaptersAsync()
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
            try await swiftDataService.saveChapterAsync(chapter)
        }
    }
    
    private func setupCloudKitSubscriptions() {
        Task {
            await subscribeToCloudKitChanges()
        }
    }
    
    private func subscribeToCloudKitChanges() async {
        let subscriptionKey = Constants.subscriptionKey
        guard !userDefaults.bool(forKey: subscriptionKey) else { return }
        
        let subscriptionId = Constants.subscriptionId
        let subscription = CKQuerySubscription(
            recordType: CloudKitType.chapterRecordType,
            predicate: NSPredicate(value: true),
            subscriptionID: subscriptionId,
            options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
        )
        
        let info = CKSubscription.NotificationInfo()
        info.shouldSendContentAvailable = true
        subscription.notificationInfo = info
        
        do {
            _ = try await database.save(subscription)
            userDefaults.set(true, forKey: subscriptionKey)
        } catch {
            syncState = .failed(.subscriptionCreationFailed(error))
        }
    }
}
extension SwiftDataService {
    func fetchAllChaptersAsync() async throws -> [Chapter] {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let result = try fetchAllChapters()
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func fetchChapterAsync(by id: Int64) async throws -> ChapterModel? {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let result = try fetchChapter(by: id)
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func saveChapterAsync(_ chapter: Chapter) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try saveChapter(chapter)
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func clearAllDataAsync() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try clearAllData()
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
