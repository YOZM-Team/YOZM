//
//  WordStudyViewModel.swift
//  YOZM
//
//  Created by 정희균 on 8/29/25.
//

import Foundation

enum WordStudyState {
    case dialogue
    case explanation
    case writingWord
    case speakingSentence
    case writingSentence
    case finish

    var currentProgressRate: Double {
        switch self {
        case .dialogue:
            0.0
        case .explanation:
            0.2
        case .writingWord:
            0.4
        case .speakingSentence:
            0.6
        case .writingSentence:
            0.8
        case .finish:
            1.0
        }
    }

    func next() -> WordStudyState? {
        switch self {
        case .dialogue:
            .explanation
        case .explanation:
            .writingWord
        case .writingWord:
            .speakingSentence
        case .speakingSentence:
            .writingSentence
        case .writingSentence:
            .finish
        case .finish:
            nil
        }
    }
}

@Observable
final class WordStudyViewModel {
    private(set) var wordStudyState: WordStudyState
    private(set) var isNextButtonEnabled: Bool

    init() {
        self.wordStudyState = .dialogue
        self.isNextButtonEnabled = false
    }

    func setIsNextButtonEnabled(_ isNextButtonEnabled: Bool) {
        self.isNextButtonEnabled = isNextButtonEnabled
    }

    func nextStudyState() {
        if let next = wordStudyState.next() {
            wordStudyState = next
            isNextButtonEnabled = false
        }
    }
}
