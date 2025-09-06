//
//  SpeakingSentenceViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Combine
import Foundation

@Observable
final class SpeakingSentenceViewModel {
    private(set) var word: Word
    private(set) var isPlaying: Bool
    private(set) var isSpeaking: Bool
    private(set) var isCorrect: Bool
    private let finishAction: (() -> Void)?

    private let audioPlayerService: AudioPlayerService
    private let speechRecognitionService: SpeechRecognitionService
    private let pronunciationScoreService: PronunciationScoreService
    private let cloudkitService: CloudKitService

    var transcription: String? {
        speechRecognitionService.result
    }

    init(
        word: Word = Word.sampleWord,
        finishAction: (() -> Void)? = nil
    ) {
        self.word = word
        self.isPlaying = false
        self.isSpeaking = false
        self.isCorrect = false
        self.finishAction = finishAction

        self.audioPlayerService = AudioPlayerService.shared
        self.speechRecognitionService = SpeechRecognitionService.shared
        self.pronunciationScoreService = PronunciationScoreService.shared
        self.cloudkitService = CloudKitService.shared
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
            GoogleAnalyticsService.shared.audioPlayed(wordId: word.id)
            try audioPlayerService.play()
            isPlaying = true
        } catch {
            GoogleAnalyticsService.shared.audioPlaybackError(
                errorType: error.localizedDescription,
                wordId: word.id
            )
            print(error.localizedDescription)
        }
    }

    func stopAudio() {
        do {
            try audioPlayerService.stop()
            isPlaying = false
        } catch {
            GoogleAnalyticsService.shared.audioPlaybackError(
                errorType: error.localizedDescription,
                wordId: word.id
            )
            print(error.localizedDescription)
        }
    }

    func startSpeaking() {
        stopAudio()
        speechRecognitionService.startTranscribing()
        isSpeaking = true
    }

    func stopSpeaking() {
        speechRecognitionService.stopTranscribing()
        isSpeaking = false
    }

    func scorePronunciation() {
        guard let transcription else { return }

        let score = pronunciationScoreService.scorePronunciation(
            reference: word.sampleSentence,
            hypothesis: transcription
        )
        if score > 0.5 {
            isCorrect = true
            stopSpeaking()
            finishAction?()
        }
    }
}
