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
                await fetchCloudKitData()
            }
        }
    }
    
    private func fetchCloudKitData() async {
        Task{
            let _ = try await CloudKitService.shared.fetchAndPrintRecord(recordIDString: "CCE66256-9702-4974-B38E-5F3F5B8C6A54")
            
            let url = try await CloudKitService.shared.fetchAudioData(recordIDString: "CCE66256-9702-4974-B38E-5F3F5B8C6A54", audioType: .sentence)
            
            let urls = try await CloudKitService.shared.fetchAudioDatas(recordIDString: "CCE66256-9702-4974-B38E-5F3F5B8C6A54")
            print("CloudKit 예문 오디오 url 조회: \(url)")
            print("CloudKit dialogue 오디오 urls 조회: \(urls)")
        }
    }
    
    private func testSwiftDataOperations() async {
        do {
            // 1. JSON 파일에서 데이터 로드
            let sampleWords = try SwiftDataService.shared.loadWordsFromJSON()
            testResult += "\n JSON에서 \(sampleWords.count)개 단어 로드 완료"
            
            // 2. SwiftData에 저장
            for sampleWord in sampleWords {
                let wordModel = WordModel(id: sampleWord.id, word: sampleWord.word)
                try SwiftDataService.shared.saveWord(wordModel)
            }
            testResult += "\n \(sampleWords.count)개 단어 저장 완료"
            
            // 3. SwiftData에서 조회
            let savedWords = try SwiftDataService.shared.fetchAllWords()
            testResult += "\n \(savedWords.count)개 단어 조회 완료"
            
            // 4. 개별 단어 조회 테스트
            for savedWord in savedWords.prefix(3) {
                let fetchedWord = try SwiftDataService.shared.fetchWord(by: savedWord.id)
                testResult += "\nID \(fetchedWord.id): \(fetchedWord.word)"
            }
            
            testResult += "\n\n 모든 테스트 완료!"
            
        } catch let error as SwiftDataServiceError {
            testResult += "\n❌ SwiftData 에러: \(error.errorDescription)"
        } catch {
            testResult += "\n❌ 일반 에러: \(error.localizedDescription)"
        }
    }
}

#Preview {
    DevView()
}
