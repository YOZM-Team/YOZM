//
//  DevView.swift
//  YOZM
//
//  Created by 정희균 on 8/25/25.
//

import SwiftUI

struct DevView: View {
    @State private var testResult = ""
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Audio Player") {
                    AudioPlayerView()
                }
                NavigationLink("Speech Recognition") {
                    SpeechRecognitionView()
                }
                NavigationLink("Pronunciation Score") {
                    PronunciationScoreView()
                }
                
                Section("SwiftData 테스트") {
                    Button("JSON → SwiftData 저장 및 조회 테스트") {
                        Task {
                            await testSwiftDataOperations()
                        }
                    }
                    
                    if !testResult.isEmpty {
                        Text(testResult)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Dev")
        }
        .onAppear{
            Task {
                try await CloudKitDataManager.shared.fetchChapter(by: 1)
            }
        }
    }
    
    private func testSwiftDataOperations() async {
        do {
            
            let sampleWords = [WordModel(id: 1, word: "느좋"), WordModel(id: 2, word: "감다살")]
            
            // 1. SwiftData에 저장
            for sampleWord in sampleWords {
                let wordModel = WordModel(id: sampleWord.id, word: sampleWord.word)
                try SwiftDataService.shared.saveWord(wordModel)
            }
            testResult += "\n \(sampleWords.count)개 단어 저장 완료"
            
            // 2. SwiftData에서 조회
            let savedWords = try SwiftDataService.shared.fetchAllWords()
            
            // 3. 개별 단어 조회 테스트
            for savedWord in savedWords {
                let fetchedWord = try SwiftDataService.shared.fetchWord(by: savedWord.id)
                testResult += "\nID \(fetchedWord.id): \(fetchedWord.word)"
            }
            
            testResult += "\n\n 모든 테스트 완료!"
            
        } catch let error as SwiftDataServiceError {
            testResult += "\n SwiftData 에러: \(error.errorDescription)"
        } catch {
            testResult += "\n 일반 에러: \(error.localizedDescription)"
        }
    }
}

#Preview {
    DevView()
}
