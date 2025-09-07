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

@MainActor
@Observable
final class DataSyncService {
    static let shared = DataSyncService()
    
    private let cloudKitService = CloudKitService.shared
    private let swiftDataService = SwiftDataService.shared
    private let userDefaults = UserDefaults.standard
    private let database = CKContainer.default().publicCloudDatabase
    
    private(set) var isSyncing = false
    private(set) var lastSyncDate: Date?
    private(set) var syncError: DataSyncError?
}
