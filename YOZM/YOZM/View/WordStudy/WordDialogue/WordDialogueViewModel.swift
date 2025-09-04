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
    
    func loadAudio() async {
        do {
            let urls = try await cloudkitService.fetchDialogueAudioURLs(wordId: word.id)
            for url in urls {
                try audioPlayerService.load(url: url)
                playAudio()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func playAudio() {
        do {
            try audioPlayerService.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
