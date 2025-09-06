//
//  GoogleAnalyticsService.swift
//  YOZM
//
//  Created by 정희균 on 9/6/25.
//

import FirebaseAnalytics
import Foundation

final class GoogleAnalyticsService {
    static let shared = GoogleAnalyticsService()

    private init() {
        self.currentScreen = nil
        self.backgroundEnteredAt = nil
    }

    private var currentScreen: GACurrentScreen?
    private var backgroundEnteredAt: Date?

    func setCurrentScreen(_ screen: GACurrentScreen) {
        currentScreen = screen
    }

    // 공통 로거 (실제 전송)
    private func log(_ event: GAEvent, _ params: [GAParam: Any] = [:]) {
        var dict: [String: Any] = [:]
        for (k, v) in params {
            // Bool/Int/Double/String만 허용되도록 보정
            switch v {
            case let b as Bool: dict[k.rawValue] = b
            case let i as Int: dict[k.rawValue] = i
            case let d as Double: dict[k.rawValue] = d
            case let s as String: dict[k.rawValue] = s
            default: dict[k.rawValue] = String(describing: v)
            }
        }
        Analytics.logEvent(event.rawValue, parameters: dict)
    }

    func appBackgrounded() {
        backgroundEnteredAt = Date()
        appBackgrounded(currentScreen: currentScreen?.rawValue ?? "nil")
    }

    func appForegrounded() {
        let now = Date()
        let backgroundDuration: TimeInterval = now.timeIntervalSince(
            backgroundEnteredAt ?? now
        )
        appForegrounded(backgroundDuration: backgroundDuration)
        backgroundEnteredAt = nil
    }

    // MARK: - 1) App Lifecycle
    private func appBackgrounded(currentScreen: String) {
        log(.app_backgrounded, [.current_screen: currentScreen])
    }

    private func appForegrounded(backgroundDuration: TimeInterval) {
        log(.app_foregrounded, [.background_duration: backgroundDuration])
    }

    // MARK: - 2) Screen Navigation
    func screenHome(userProgressPercent: Double) {
        log(.screen_home, [.user_progress_percent: userProgressPercent])
    }

    func screenStageList(
        chapterName: String,
        totalStages: Int,
        completedStages: Int
    ) {
        log(
            .screen_stage_list,
            [
                .chapter_name: chapterName,
                .total_stages: totalStages,
                .completed_stages: completedStages,
            ]
        )
    }

    func screenLearning(chapterName: String, stageName: String, wordId: Int64) {
        log(
            .screen_learning,
            [
                .chapter_name: chapterName,
                .stage_name: stageName,
                .word_id: wordId,
            ]
        )
    }

    func screenWordCollection(totalLearnedWords: Int) {
        log(.screen_word_collection, [.total_learned_words: totalLearnedWords])
    }

    // MARK: - 3) Learning Progress
    func learningStepStarted(
        wordId: Int64,
        chapterName: String,
        stageName: String
    ) {
        log(
            .learning_step_started,
            [
                .word_id: wordId,
                .chapter_name: chapterName,
                .stage_name: stageName,
            ]
        )
    }

    func learningStepCompleted(wordId: Int64, result: Bool) {
        log(
            .learning_step_completed,
            [
                .word_id: wordId,
                .result: result,
            ]
        )
    }

    // MARK: - 4) Learning Steps
    func textDramaViewed(wordId: Int64) {
        log(.text_drama_viewed, [.word_id: wordId])
    }

    func wordExplanationViewed(wordId: Int64) {
        log(.word_explanation_viewed, [.word_id: wordId])
    }

    func audioPlayed(wordId: Int64) {
        log(.audio_played, [.word_id: wordId])
    }

    func pronunciationPracticeStarted(wordId: Int64) {
        log(.pronunciation_practice_started, [.word_id: wordId])
    }

    func pronunciationPracticeCompleted(wordId: Int64) {
        log(.pronunciation_practice_completed, [.word_id: wordId])
    }

    func inputWordTestStarted(wordId: Int64) {
        log(.input_word_test_started, [.word_id: wordId])
    }

    func inputWordTestCompleted(wordId: Int64, correct: Bool, attempts: Int) {
        log(
            .input_word_test_completed,
            [
                .word_id: wordId,
                .correct: correct,
                .attempts: attempts,
            ]
        )
    }

    func inputSentenceTestStarted(wordId: Int64) {
        log(.input_sentence_test_started, [.word_id: wordId])
    }

    func inputSentenceTestCompleted(wordId: Int64, correct: Bool, attempts: Int)
    {
        log(
            .input_sentence_test_completed,
            [
                .word_id: wordId,
                .correct: correct,
                .attempts: attempts,
            ]
        )
    }

    // MARK: - 5) Content Analytics
    func chapterDropout(chapterName: String, dropoutStage: String) {
        log(
            .chapter_dropout,
            [
                .chapter_name: chapterName,
                .dropout_stage: dropoutStage,
            ]
        )
    }

    // MARK: - 6) Errors & Technical
    func audioPlaybackError(errorType: String, wordId: Int64) {
        log(
            .audio_playback_error,
            [
                .error_type: errorType,
                .word_id: wordId,
            ]
        )
    }

    func speechRecognitionError(errorCode: String, wordId: Int64) {
        log(
            .speech_recognition_error,
            [
                .error_code: errorCode,
                .word_id: wordId,
            ]
        )
    }

    func networkError(errorType: String, retryCount: Int) {
        log(
            .network_error,
            [
                .error_type: errorType,
                .retry_count: retryCount,
            ]
        )
    }
}
