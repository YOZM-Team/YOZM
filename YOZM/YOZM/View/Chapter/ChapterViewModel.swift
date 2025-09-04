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
    
    private let cloudKitService: CloudKitService
    
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

    init(chapter: Chapter = .sample) {
        self.chapter = chapter
        self.latestCompleteWord = nil
        self.cloudKitService = CloudKitService.shared
    }
    
    func fetchData() async {
        do {
            self.chapter = try await cloudKitService.fetchChapter(by: 1)
        } catch {
            print(error.localizedDescription)
        }
    }
}
