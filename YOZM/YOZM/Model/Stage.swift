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
