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
    
    private static func extractField<T>(_ record: CKRecord, field: CloudKitField, as type: T.Type) throws -> T {
        guard let value = record[field.rawValue] as? T else {
            throw CloudKitError.missingField(field: field.rawValue)
        }
        return value
    }
    
    func fetchChapter(by id: Int64) async throws -> Chapter {
        do {
            let chapterRecord = try await fetchRecord(
                recordType: CloudKitType.chapterRecordType,
                predicate: NSPredicate(format: "\(CloudKitField.id.rawValue) == %lld", id)
            )
            
            let chapter = try await buildChapter(from: chapterRecord)
            print("[CloudKitFetcher] 챕터 조회 완료 - 제목: \(chapter.title)")
            return chapter
        } catch {
            print("[CloudKitFetcher] 챕터 조회 중 오류 발생: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func buildChapter(from record: CKRecord) async throws -> Chapter {
        let id = try Self.extractField(record, field: .id, as: Int64.self)
        let title = try Self.extractField(record, field: .title, as: String.self)
        let stages = try await fetchStages(for: record)
        
        return Chapter(id: id, title: title, stages: stages)
    }
    
    private func fetchRecord(recordType: String, predicate: NSPredicate) async throws -> CKRecord {
        do {
            let query = CKQuery(recordType: recordType, predicate: predicate)
            let (results, _) = try await publicDatabase.records(matching: query)
            
            guard let (_, firstResult) = results.first,
                  case .success(let record) = firstResult else {
                throw CloudKitError.recordNotFound
            }
            
            return record
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func fetchRecords(recordType: String, predicate: NSPredicate, sortBy: String? = nil) async throws -> [CKRecord] {
        do {
            let query = CKQuery(recordType: recordType, predicate: predicate)
            
            if let sortBy = sortBy {
                query.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true)]
            }
            
            let (results, _) = try await publicDatabase.records(matching: query)
            
            var records: [CKRecord] = []
            for (_, result) in results {
                switch result {
                case .success(let record):
                    records.append(record)
                case .failure(let error):
                    throw error
                }
            }
            return records
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func fetchStages(for chapterRecord: CKRecord) async throws -> [Stage] {
        do {
            let stageRecords = try await fetchRecords(
                recordType: CloudKitType.stageRecordType,
                predicate: NSPredicate(format: "\(CloudKitField.chapterReference.rawValue) == %@", chapterRecord),
                sortBy: CloudKitField.id.rawValue
            )
            
            let stages = try await processRecordsConcurrently(stageRecords, transform: buildStage)
            print("[CloudKitFetcher] 스테이지 조회 완료 - 총 \(stages.count)개")
            return stages
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func buildStage(from record: CKRecord) async throws -> Stage {
        let id = try Self.extractField(record, field: .id, as: Int64.self)
        let title = try Self.extractField(record, field: .title, as: String.self)
        let words = try await fetchWords(for: record)
        
        return Stage(id: id, title: title, words: words)
    }
    
    private func fetchWords(for stageRecord: CKRecord) async throws -> [Word] {
        do {
            let wordRecords = try await fetchRecords(
                recordType: CloudKitType.wordRecordType,
                predicate: NSPredicate(format: "\(CloudKitField.stageReference.rawValue) == %@", stageRecord),
                sortBy: CloudKitField.id.rawValue
            )
            
            let words = try await processRecordsConcurrently(wordRecords, transform: buildWord)
            print("[CloudKitFetcher] 단어 조회 완룼 - 총 \(words.count)개")
            return words
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func buildWord(from record: CKRecord) async throws -> Word {
        let id = try Self.extractField(record, field: .id, as: Int64.self)
        let word = try Self.extractField(record, field: .word, as: String.self)
        let meaning = try Self.extractField(record, field: .meaning, as: String.self)
        let pronunciation = try Self.extractField(record, field: .pronunciation, as: String.self)
        let sampleSentence = try Self.extractField(record, field: .sampleSentence, as: String.self)
        let dialogues = try await fetchDialogues(for: record)
        
        return Word(
            id: id,
            word: word,
            meaning: meaning,
            pronunciation: pronunciation,
            sampleSentence: sampleSentence,
            sampleDialogue: dialogues
        )
    }
    
    private func fetchDialogues(for wordRecord: CKRecord) async throws -> [Dialogue] {
        do {
            let dialogueRecords = try await fetchRecords(
                recordType: CloudKitType.dialogueRecordType,
                predicate: NSPredicate(format: "\(CloudKitField.wordReference.rawValue) == %@", wordRecord),
                sortBy: CloudKitField.id.rawValue
            )
            
            let dialogues = try dialogueRecords.map(buildDialogue)
            print("[CloudKitFetcher] 대화문 조회 완료 - 총 \(dialogues.count)개")
            return dialogues
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func buildDialogue(from record: CKRecord) throws -> Dialogue {
        let id = try Self.extractField(record, field: .id, as: Int64.self)
        let sentence = try Self.extractField(record, field: .sentence, as: String.self)
        let speakerType = try Self.extractField(record, field: .speakerType, as: Int64.self)
        
        return Dialogue(id: id, speakerType: speakerType, sentence: sentence)
    }
    
    private func processRecordsConcurrently<T>(_ records: [CKRecord], transform: @escaping (CKRecord) async throws -> T) async throws -> [T] {
        return try await withThrowingTaskGroup(of: T.self) { group in
            for record in records {
                group.addTask {
                    try await transform(record)
                }
            }
            
            var results: [T] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
    }
}
