//
//  WordModel.swift
//  YOZM
//
//  Created by Claude on 8/27/25.
//

import Foundation
import SwiftData

@Model
final class WordModel {
    var wordID: Int
    var word: String
    
    init(wordID: Int, word: String) {
        self.wordID = wordID
        self.word = word
    }
}