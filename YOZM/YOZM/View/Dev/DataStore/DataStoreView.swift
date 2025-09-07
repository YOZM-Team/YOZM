//
//  DataStoreView.swift
//  YOZM
//
//  Created by 최희진 on 9/3/25.
//

import SwiftUI

struct DataStoreView: View {
    private let cloudKitService = CloudKitService.shared
    private let dataSyncService = DataSyncService.shared
    
    @State private var syncStatus = "Ready"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                syncStatusSection
                cloudKitSyncSection
                swiftDataSection
                cloudKitSection
            }
            .padding()
        }
    }
    
    private var syncStatusSection: some View {
        VStack {
            Text("동기화 상태")
                .font(.headline)
            Text(syncStatus)
                .foregroundColor(.secondary)
        }
        .padding()
        .cornerRadius(8)
    }
    
    private var cloudKitSyncSection: some View {
        VStack {
            Text("CloudKit 동기화")
                .font(.headline)
            
            Button("데이터 동기화 시작") {
                Task {
                    syncStatus = "동기화 중..."
                    await dataSyncService.syncDataIfNeeded()
                    syncStatus = "동기화 완료"
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .cornerRadius(8)
    }
    
    private var cloudKitSection: some View {
        VStack {
            Text("CloudKit 직접 호출")
                .font(.headline)
            
            Button("CloudKit 저장") {
                Task {
                    try await cloudKitService.upload()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .cornerRadius(8)
    }
    
    private var swiftDataSection: some View {
        VStack {
            Text("SwiftData 관리")
                .font(.headline)
            
            HStack {
                Button("챕터 조회") {
                    Task {
                        await fetchChapters()
                    }
                }
                .buttonStyle(.bordered)
                
                Button("데이터 초기화") {
                    Task {
                        await clearAllData()
                    }
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
        .padding()
        .cornerRadius(8)
    }
    
    private func fetchChapters() async {
        Task {
            let chapters = try await dataSyncService.fetchChaptersFromSwiftData()
            
            await MainActor.run {
                syncStatus = "챕터 \(chapters.count)개 조회됨"
            }
            for chapter in chapters {
                print("챕터: \(chapter.title) (ID: \(chapter.id))")
                for stage in chapter.stages {
                    print("스테이지: \(stage.title) (단어 \(stage.words.count)개)")
                }
            }
        }
    }
    
    private func clearAllData() async {
        
        Task {
            try await dataSyncService.clearAllData()
        }
        await MainActor.run {
            syncStatus = "모든 데이터 삭제 완료"
        }
        print("✅ 모든 SwiftData 삭제 완료")
    }
}

#Preview {
    SpeechRecognitionView()
}
