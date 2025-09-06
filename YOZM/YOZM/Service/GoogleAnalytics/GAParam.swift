//
//  GAParam.swift
//  YOZM
//
//  Created by 정희균 on 9/6/25.
//

enum GAParam: String {
    // 1. App Lifecycle
    case current_screen
    case background_duration  // seconds

    // 2. Screen Navigation
    case user_progress_percent
    case chapter_name
    case total_stages
    case completed_stages
    case stage_name
    case word_id
    case total_learned_words

    // 3. Learning Progress
    case result

    // 4. Learning Steps
    case correct
    case attempts

    // 5. Content Analytics
    case dropout_stage

    // 6. Errors & Technical
    case error_type
    case error_code
    case retry_count
}
