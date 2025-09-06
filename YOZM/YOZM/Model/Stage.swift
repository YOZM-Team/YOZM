//
//  Stage.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import Foundation

struct Stage: Codable {
    let id: Int64
    let title: String
    let words: [Word]
}

extension Stage {
    static var sample: Stage {
        Stage(
            id: 0,
            title: "LotteWorldTower",
            words: Array(repeating: .sampleWord, count: 5)
        )
    }
}
