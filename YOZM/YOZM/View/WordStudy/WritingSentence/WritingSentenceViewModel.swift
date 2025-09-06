//
//  WritingSentenceViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Foundation

@Observable
final class WritingSentenceViewModel {
    private(set) var word: Word
    private(set) var isShowingHint: Bool
    private(set) var isPlaying: Bool
    private(set) var text: String
    var isCorrect: Bool {
        text == word.sampleSentence
    }

    private let finishAction: (() -> Void)?
    
    private let audioPlayerService: AudioPlayerService
    private let cloudkitService: CloudKitService

    init(word: Word = Word.sampleWord, finishAction: (() -> Void)? = nil) {
        self.word = word
        self.isShowingHint = false
        self.isPlaying = false
        self.text = ""

        self.finishAction = finishAction
        self.cloudkitService = CloudKitService.shared
        self.audioPlayerService = AudioPlayerService.shared
    }

    func setIsShowingHint(_ isShowingHint: Bool) {
        self.isShowingHint = isShowingHint
    }

    func loadAudio() async {
        do {
            let url = try await cloudkitService.fetchSentenceAudioURL(wordId: word.id)
            try audioPlayerService.load(url: url)
        } catch {
            print(error.localizedDescription)
        }
    }

    func playAudio() {
        do {
            try audioPlayerService.play()
            isPlaying = true
        } catch {
            print(error.localizedDescription)
        }
    }

    func stopAudio() {
        do {
            try audioPlayerService.stop()
            isPlaying = false
        } catch {
            print(error.localizedDescription)
        }
    }

    func setText(_ text: String) {
        self.text = text

        if isCorrect {
            finishAction?()
        }
    }
}
