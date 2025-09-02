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
        print("📤 [CloudKitUploader] 업로드 시작 - 총 \(chapters.count)개 챕터")
        do {
            try await uploadChapters(chapters)
            print("✅ [CloudKitUploader] 모든 챕터 업로드 완료!")
        } catch {
            let errorMessage = "업로드 중 발생한 에러: \(error.localizedDescription)"
            print("❌ [CloudKitUploader] \(errorMessage)")
            throw CloudKitError.invalidData(errorMessage)
        }
    }
    
    private func uploadChapters(_ chapters: [Chapter]) async throws {
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for chapter in chapters {
                    group.addTask {
                        try await self.uploadChapter(chapter)
                    }
                }
                try await group.waitForAll()
            }
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func uploadChapter(_ chapter: Chapter) async throws {
        do {
            let chapterCloudKit = ChapterCloudKit(id: chapter.id, title: chapter.title)
            let savedChapterRecord = try await publicDatabase.save(chapterCloudKit.record)
            
            for stage in chapter.stages {
                try await uploadStage(stage, chapterRecord: savedChapterRecord)
            }
            print("[CloudKitUploader] 챕터 업로드 완료 - ID: \(chapter.id)")
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
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
        print("[CloudKitUploader] 스테이지 업로드 완료 - ID: \(stage.id)")
    }
    
    private func uploadWord(_ word: Word, stageRecord: CKRecord) async throws {
        do {
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
            print("[CloudKitUploader] 단어 업로드 완료 - ID: \(word.id)")
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func uploadDialogue(_ dialogue: Dialogue, wordRecord: CKRecord) async throws {
        do {
            let dialogueCloudKit = DialogueCloudKit(
                id: dialogue.id,
                sentence: dialogue.sentence,
                speakerType: dialogue.speakerType,
                wordRecord: wordRecord
            )
            
            _ = try await publicDatabase.save(dialogueCloudKit.record)
            
            print("[CloudKitUploader] 대화문 저장 완료 - ID: \(dialogue.id)")
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
}
