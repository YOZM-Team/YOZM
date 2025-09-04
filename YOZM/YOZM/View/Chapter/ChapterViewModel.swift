//
//  ChapterViewModel.swift
//  YOZM
//
//  Created by 정희균 on 9/3/25.
//

import Foundation

@Observable
final class ChapterViewModel {
    private(set) var chapter: Chapter
    private(set) var lastestCompleteWord: Word?
    var availableWords: [Int64: Bool] {
        var isAvailable = true
        var foundTarget: Bool = false

        if lastestCompleteWord == nil {
            foundTarget = true
        }

        var available: [Int64: Bool] = [:]
        for stage in chapter.stages {
            for word in stage.words {
                available[word.id] = isAvailable

                if foundTarget == true {
                    isAvailable = false
                }

                if word.id == lastestCompleteWord?.id {
                    foundTarget = true
                }
            }
        }

        return available
    }

    init(chapter: Chapter = .sample) {
        self.chapter = chapter
        self.lastestCompleteWord = nil
    }
}
