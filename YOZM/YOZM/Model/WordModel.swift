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
    var id: Int64 = 0
    var word: String = "Unknown"
    
    init(id: Int64, word: String) {
        self.id = id
        self.word = word
    }
}
