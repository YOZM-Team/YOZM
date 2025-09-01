//
//  CloudKitUploaderService.swift
//  YOZM
//
//  Created by 최희진 on 9/1/25.
//

import Foundation
import CloudKit

final class CloudKitUploaderService {
    private let container = CKContainer.default()
    private let publicDatabase: CKDatabase
    
    init() {
        self.publicDatabase = container.publicCloudDatabase
    }
    
    func upload(chapters: [Chapter]) async throws {
        try await uploadChapters(chapters)
    }
    
    private func uploadChapters(_ chapters: [Chapter]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for chapter in chapters {
                group.addTask {
                    try await self.uploadChapter(chapter)
                }
            }
            try await group.waitForAll()
        }
    }
    
    private func uploadChapter(_ chapter: Chapter) async throws {
        let chapterCloudKit = ChapterCloudKit(id: chapter.id, title: chapter.title)
        let savedChapterRecord = try await publicDatabase.save(chapterCloudKit.record)
        
        for stage in chapter.stages {
            try await uploadStage(stage, chapterRecord: savedChapterRecord)
        }
    }
    
    private func uploadStage(_ stage: Stage, chapterRecord: CKRecord) async throws {
        let stageCloudKit = StageCloudKit(
            id: stage.id,
            title: stage.title,
            chapterRecord: chapterRecord
        )
        let savedStageRecord = try await publicDatabase.save(stageCloudKit.record)
        
        for word in stage.words {
            try await uploadWord(word, stageRecord: savedStageRecord)
        }
    }
    
    private func uploadWord(_ word: Word, stageRecord: CKRecord) async throws {
        let dialogueStrings = word.sampleDialogue.map { $0.sentence }
        
        let wordCloudKit = WordCloudKit(
            id: word.id,
            word: word.word,
            meaning: word.meaning,
            pronunciation: word.pronunciation,
            sampleSentence: word.sampleSentence,
            sampleDialogue: dialogueStrings,
            stageRecord: stageRecord
        )
        
        let savedWordRecord = try await publicDatabase.save(wordCloudKit.record)
        
        for dialogue in word.sampleDialogue {
            try await uploadDialogue(dialogue, wordRecord: savedWordRecord)
        }
    }
    
    private func uploadDialogue(_ dialogue: Dialogue, wordRecord: CKRecord) async throws {
        let dialogueCloudKit = DialogueCloudKit(
            id: dialogue.id,
            sentence: dialogue.sentence,
            speakerType: dialogue.speakerType,
            wordRecord: wordRecord
        )
        
        _ = try await publicDatabase.save(dialogueCloudKit.record)
    }
}
