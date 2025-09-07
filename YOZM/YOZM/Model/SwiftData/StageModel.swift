//
//  StageModel.swift
//  YOZM
//
//  Created by 최희진 on 9/7/25.
//

import Foundation
import SwiftData

@Model
final class StageModel {
    var id: Int64 = 0
    var title: String = ""
    @Relationship(inverse: \ChapterModel.stages) var chapter: ChapterModel?
    @Relationship(deleteRule: .cascade) var words: [WordModel]?
    
    init(id: Int64, title: String) {
        self.id = id
        self.title = title
        self.words = []
    }
}

extension StageModel {
    func toStage() -> Stage {
        Stage(
            id: self.id,
            title: self.title,
            words: (self.words ?? []).map { $0.toWord() }
        )
    }
    
    static func from(_ stage: Stage) -> StageModel {
        let model = StageModel(id: stage.id, title: stage.title)
        return model
    }
}
