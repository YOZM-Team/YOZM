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
    private(set) var latestCompleteWord: Word?
    var availableWords: [Int64: Bool] {
        var isAvailable = true
        var foundTarget: Bool = false

        if latestCompleteWord == nil {
            foundTarget = true
        }

        var available: [Int64: Bool] = [:]
        for stage in chapter.stages {
            for word in stage.words {
                available[word.id] = isAvailable

                if foundTarget == true {
                    isAvailable = false
                }

                if word.id == latestCompleteWord?.id {
                    foundTarget = true
                }
            }
        }

        return available
    }
    private var scrollViewHeight: CGFloat
    private var scrollViewOffsetY: CGFloat
    private(set) var backgroundHeight: CGFloat
    var backgroundOffsetY: CGFloat {
        let maxY = backgroundHeight - scrollViewHeight
        return min(.zero, max(-maxY, scrollViewOffsetY))
    }

    init(chapter: Chapter = .sample) {
        self.chapter = chapter
        self.latestCompleteWord = nil
        self.scrollViewHeight = .zero
        self.scrollViewOffsetY = .zero
        self.backgroundHeight = .zero
    }

    func setScrollViewFrame(_ frame: CGRect) {
        self.scrollViewOffsetY = frame.minY
        self.backgroundHeight = frame.height
    }

    func setScrollViewSize(_ size: CGSize) {
        self.scrollViewHeight = size.height
    }
}
