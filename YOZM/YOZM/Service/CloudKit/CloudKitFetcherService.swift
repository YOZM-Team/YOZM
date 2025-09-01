//
//  CloudKitFetcherService.swift
//  YOZM
//
//  Created by 최희진 on 9/1/25.
//

import Foundation
import CloudKit

final class CloudKitFetcherService {
    private let container = CKContainer.default()
    private let publicDatabase: CKDatabase
    
    init() {
        self.publicDatabase = container.publicCloudDatabase
    }

    // MARK: - Public Methods
    func fetchChapter(by id: Int64) async throws -> Chapter {
        let chapterRecord = try await fetchRecord(
            recordType: CloudKitType.chapterRecordType,
            predicate: NSPredicate(format: "id == %lld", id)
        )
        
        let chapterCloudKit = ChapterCloudKit(record: chapterRecord)
        let stages = try await fetchStages(for: chapterRecord)
        
        print("[CloudKit] 챕터 조회 완료 - 제목: \(String(describing: chapterCloudKit.title))")
        
        return Chapter(
            id: try chapterCloudKit.id(),
            title: try chapterCloudKit.title(),
            stages: stages
        )
    }
    
    // MARK: - Private Helper Methods
    private func fetchRecord(recordType: String, predicate: NSPredicate) async throws -> CKRecord {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let (results, _) = try await publicDatabase.records(matching: query)
        
        guard let (_, firstResult) = results.first,
              case .success(let record) = firstResult else {
            throw CloudKitError.recordNotFound
        }
        
        return record
    }
    
    private func fetchRecords(recordType: String, predicate: NSPredicate, sortBy: String? = nil) async throws -> [CKRecord] {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        if let sortBy = sortBy {
            query.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true)]
        }
        
        let (results, _) = try await publicDatabase.records(matching: query)
        
        return results.compactMap { (_, result) in
            switch result {
            case .success(let record):
                return record
            case .failure:
                return nil
            }
        }
    }
    
    private func fetchStages(for chapterRecord: CKRecord) async throws -> [Stage] {
        let stageRecords = try await fetchRecords(
            recordType: CloudKitType.stageRecordType,
            predicate: NSPredicate(format: "chapterReference == %@", chapterRecord),
            sortBy: "id"
        )
        
        let stages = try await processRecordsConcurrently(stageRecords) { stageRecord in
            let stageCloudKit = StageCloudKit(record: stageRecord)
            let words = try await self.fetchWords(for: stageRecord)
            
            return Stage(
                id: try stageCloudKit.id(),
                title: try stageCloudKit.title(),
                words: words
            )
        }
        
        let sortedStages = stages.sorted { $0.id < $1.id }
        print("[CloudKit] 스테이지 조회 완료 - 총 \(sortedStages.count)개")
        
        return sortedStages
    }
    
    private func fetchWords(for stageRecord: CKRecord) async throws -> [Word] {
        let wordRecords = try await fetchRecords(
            recordType: CloudKitType.wordRecordType,
            predicate: NSPredicate(format: "stageReference == %@", stageRecord)
        )
        
        let words = try await processRecordsConcurrently(wordRecords) { wordRecord in
            let wordCloudKit = WordCloudKit(record: wordRecord)
            let dialogues = try await self.fetchDialogues(for: wordRecord)
            
            return Word(
                id: wordCloudKit.id,
                word: wordCloudKit.word,
                meaning: wordCloudKit.meaning,
                pronunciation: wordCloudKit.pronunciation,
                sampleSentence: wordCloudKit.sampleSentence,
                sampleDialogue: dialogues
            )
        }
        
        let sortedWords = words.sorted { $0.id < $1.id }
        print("[CloudKit] 단어 조회 완료 - 총 \(sortedWords.count)개")
        
        return sortedWords
    }
    
    private func fetchDialogues(for wordRecord: CKRecord) async throws -> [Dialogue] {
        let dialogueRecords = try await fetchRecords(
            recordType: CloudKitType.dialogueRecordType,
            predicate: NSPredicate(format: "wordReference == %@", wordRecord)
        )
        
        let dialogues: [Dialogue] = try dialogueRecords.map { dialogueRecord in
            let dialogueCloudKit = DialogueCloudKit(record: dialogueRecord)
            return Dialogue(
                id: try dialogueCloudKit.id(),
                speakerType: try dialogueCloudKit.speakerType(),
                sentence: try dialogueCloudKit.sentence()
            )
        }
        
        let sortedDialogues = dialogues.sorted { $0.id < $1.id }
        print("[CloudKit] 대화문 조회 완료 - 총 \(sortedDialogues.count)개")
        
        return dialogues.sorted { $0.id < $1.id }
    }
    
    private func processRecordsConcurrently<T>(_ records: [CKRecord], transform: @escaping (CKRecord) async throws -> T) async throws -> [T] {
        return try await withThrowingTaskGroup(of: T?.self) { group in
            for record in records {
                group.addTask {
                    do {
                        return try await transform(record)
                    } catch {
                        print("Error processing record: \(error)")
                        return nil
                    }
                }
            }
            
            var results: [T] = []
            for try await result in group {
                if let result = result {
                    results.append(result)
                }
            }
            return results
        }
    }
}
