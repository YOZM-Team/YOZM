//
//  Chapter.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import Foundation

struct ChapterData: Codable {
    let chapters: [Chapter]
}

struct Chapter: Codable {
    let id: Int64
    let title: String
    let stages: [Stage]
}

extension Chapter {
    static var sample: Chapter {
        let words = (0..<20).map {
            Word(
                id: $0,
                word: "\($0)",
                meaning: "테스트",
                pronunciation: "발음",
                sampleSentence: "예문",
                sampleDialogue: [
                    Dialogue(id: 0, speakerType: 0, sentence: "대화")
                ]
            )
        }

        return Chapter(
            id: 0,
            title: "서울",
            stages: [
                Stage(
                    id: 0,
                    title: "LotteWorldTower",
                    words: Array(words[0..<5])
                ),
                Stage(id: 1, title: "Hangang", words: Array(words[5..<10])),
                Stage(
                    id: 2,
                    title: "Gyeongbokgung",
                    words: Array(words[10..<15])
                ),
                Stage(
                    id: 3,
                    title: "NamsanSeoulTower",
                    words: Array(words[15..<20])
                ),
            ]
        )
    }
}
