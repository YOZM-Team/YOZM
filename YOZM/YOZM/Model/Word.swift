//
//  Word.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import Foundation

struct Word: Codable {
    let id: Int64
    let word: String
    let meaning: String
    let pronunciation: String
    let sampleSentence: String
    let sampleDialogue: [String]
}
