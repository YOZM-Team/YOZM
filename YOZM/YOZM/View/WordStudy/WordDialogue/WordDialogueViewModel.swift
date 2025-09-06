//
//  WordDialogueViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Foundation

@Observable
final class WordDialogueViewModel {
    private(set) var word: Word
    private(set) var dialogue: [Dialogue]
    private(set) var isPlayingSequence: Bool = false
    private var audioURLs: [URL] = []
    let finishAction: (() -> Void)?
    
    private let audioPlayerService: AudioPlayerService
    private let cloudkitService: CloudKitService

    init(
        word: Word = Word.sampleWord,
        finishAction: (() -> Void)? = nil
    ) {
        self.word = word
        self.dialogue = word.sampleDialogue
        self.finishAction = finishAction
        self.audioPlayerService = AudioPlayerService.shared
        self.cloudkitService = CloudKitService.shared
    }
    
    func loadAndPlayAudioSequence() async {
        do {
            let urls = try await cloudkitService.fetchDialogueAudioURLs(wordId: word.id)
            audioURLs = urls
            
            await playAudioSequence()
        } catch {
            print("오디오 로드 실패: \(error.localizedDescription)")
        }
    }
    
    private func playAudioSequence() async {
        guard !audioURLs.isEmpty else { return }
        
        isPlayingSequence = true
        
        for url in audioURLs {
            do {
                try audioPlayerService.load(url: url)
                try await audioPlayerService.playAndWait()
                
                // 대화 간 간격
                try await Task.sleep(for: .seconds(0.5))
                
            } catch {
                print("오디오 재생 실패: \(error.localizedDescription)")
            }
        }
        isPlayingSequence = false
    }
}
