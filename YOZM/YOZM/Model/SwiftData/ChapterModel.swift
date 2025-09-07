//
//  ChapterModel.swift
//  YOZM
//
//  Created by 최희진 on 9/7/25.
//

import Foundation
import SwiftData

@Model
final class ChapterModel {
    var id: Int64 = 0
    var title: String = ""
    @Relationship(deleteRule: .cascade) var stages: [StageModel]?
    
    init(id: Int64, title: String) {
        self.id = id
        self.title = title
        self.stages = []
    }
}

extension ChapterModel {
    func toChapter() -> Chapter {
        Chapter(
            id: self.id,
            title: self.title,
            stages: (self.stages ?? []).map { $0.toStage() }
        )
    }
    
    static func from(_ chapter: Chapter) -> ChapterModel {
        let model = ChapterModel(id: chapter.id, title: chapter.title)
        return model
    }
}
