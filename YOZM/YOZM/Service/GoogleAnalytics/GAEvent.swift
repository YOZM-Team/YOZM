//
//  GAEvent.swift
//  YOZM
//
//  Created by 정희균 on 9/5/25.
//

enum GAEvent: String {
    // 1. App Lifecycle
    case app_backgrounded
    case app_foregrounded

    // 2. Screen Navigation
    case screen_home
    case screen_stage_list
    case screen_learning
    case screen_word_collection

    // 3. Learning Progress
    case learning_step_started
    case learning_step_completed

    // 4. Learning Steps
    case text_drama_viewed
    case word_explanation_viewed
    case audio_played
    case pronunciation_practice_started
    case pronunciation_practice_completed
    case input_word_test_started
    case input_word_test_completed
    case input_sentence_test_started
    case input_sentence_test_completed

    // 5. Content Analytics
    case chapter_dropout

    // 6. Errors & Technical
    case audio_playback_error
    case speech_recognition_error
    case network_error
}
