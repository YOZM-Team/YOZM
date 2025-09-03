//
//  DataStoreView.swift
//  YOZM
//
//  Created by 최희진 on 9/3/25.
//

import SwiftUI

struct DataStoreView: View {
    private let cloudKitService = CloudKitService.shared
    private let swiftDataService = SwiftDataService.shared
    
    var body: some View {
        VStack {
            cloudKitSection
            swiftDataSection
        }
        .padding()
    }
    
    private var cloudKitSection: some View {
        
        VStack{
            Button("CloudKit 저장") {
                Task {
                    try await cloudKitService.upload()
                }
            }
            .buttonStyle(.bordered)
            
            Button("CloudKit 조회") {
                Task {
                    try await cloudKitService.fetchChapter(by: 1)
                }
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var swiftDataSection: some View {
        VStack{
            Button("SwiftData 저장") {
                Task {
                    await storeSwiftData()
                }
            }
            .buttonStyle(.bordered)
            
            Button("SwiftData 조회") {
                Task {
                    await fetchSwiftData()
                }
            }
            .buttonStyle(.bordered)
        }
    }
    
    private func storeSwiftData() async {
        do {
            let sampleWords = [WordModel(id: 1, word: "느좋"), WordModel(id: 2, word: "감다살")]
            for sampleWord in sampleWords {
                try SwiftDataService.shared.saveWord(sampleWord)
            }
            print("\n \(sampleWords.count)개 단어 저장 완료")
        } catch {
            print("\n 일반 에러: \(error.localizedDescription)")
        }
    }
    
    private func fetchSwiftData() async {
        do {
            let savedWords = try SwiftDataService.shared.fetchAllWords()
            for savedWord in savedWords{
                print("\n SwiftData 조회 완료: \(savedWord.word)")
            }
        } catch {
            print("\n 일반 에러: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SpeechRecognitionView()
}
