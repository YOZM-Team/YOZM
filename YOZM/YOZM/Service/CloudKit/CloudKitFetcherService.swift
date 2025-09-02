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
    
    func fetchChapter(by id: Int64) async throws -> Chapter {
        do {
            let chapterRecord = try await fetchRecord(
                recordType: CloudKitType.chapterRecordType,
                predicate: NSPredicate(format: "\(CloudKitField.id.rawValue) == %lld", id)
            )
            guard let id = chapterRecord[CloudKitField.id.rawValue] as? Int64 else {
                throw CloudKitError.missingField(field: CloudKitField.id.rawValue)
            }
            guard let title = chapterRecord[CloudKitField.title.rawValue] as? String else {
                throw CloudKitError.missingField(field: CloudKitField.title.rawValue)
            }
            
            let stages = try await fetchStages(for: chapterRecord)
            
            print("[CloudKitFetcher] 챕터 조회 완료 - 제목: \(title)")
            
            return Chapter(
                id: id,
                title: title,
                stages: stages
            )
        } catch {
            print("[CloudKitFetcher] 챕터 조회 중 오류 발생: \(error.localizedDescription)")
            throw error
        }
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
            
            return results.compactMap { (_, result) in
                switch result {
                case .success(let record):
                    return record
                case .failure:
                    return nil
                }
            }
        } catch {
            throw error
        }
    }
    
    private func fetchStages(for chapterRecord: CKRecord) async throws -> [Stage] {
        do {
            let stageRecords = try await fetchRecords(
                recordType: CloudKitType.stageRecordType,
                predicate: NSPredicate(format: "\(CloudKitField.chapterReference.rawValue) == %@", chapterRecord),
                sortBy: "\(CloudKitField.id.rawValue)"
            )
            
            let stages = try await processRecordsConcurrently(stageRecords) { stageRecord in
                guard let id = stageRecord[CloudKitField.id.rawValue] as? Int64 else {
                    throw CloudKitError.missingField(field: CloudKitField.id.rawValue)
                }
                guard let title = stageRecord[CloudKitField.title.rawValue] as? String else {
                    throw CloudKitError.missingField(field: CloudKitField.title.rawValue)
                }
                
                let words = try await self.fetchWords(for: stageRecord)
                
                return Stage(
                    id: id,
                    title: title,
                    words: words
                )
            }
            
            print("[CloudKitFetcher] 스테이지 조회 완료 - 총 \(stages.count)개")
            
            return stages
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func fetchWords(for stageRecord: CKRecord) async throws -> [Word] {
        do {
            let wordRecords = try await fetchRecords(
                recordType: CloudKitType.wordRecordType,
                predicate: NSPredicate(format: "\(CloudKitField.stageReference.rawValue) == %@", stageRecord),
                sortBy: "\(CloudKitField.id.rawValue)"
            )
            
            let words = try await processRecordsConcurrently(wordRecords) { wordRecord in
                guard let id = wordRecord[CloudKitField.id.rawValue] as? Int64 else {
                    throw CloudKitError.missingField(field: CloudKitField.id.rawValue)
                }
                guard let word = wordRecord[CloudKitField.word.rawValue] as? String else {
                    throw CloudKitError.missingField(field: CloudKitField.word.rawValue)
                }
                guard let meaning = wordRecord[CloudKitField.meaning.rawValue] as? String else {
                    throw CloudKitError.missingField(field: CloudKitField.meaning.rawValue)
                }
                guard let pronunciation = wordRecord[CloudKitField.pronunciation.rawValue] as? String else {
                    throw CloudKitError.missingField(field: CloudKitField.pronunciation.rawValue)
                }
                guard let sampleSentence = wordRecord[CloudKitField.sampleSentence.rawValue] as? String else {
                    throw CloudKitError.missingField(field: CloudKitField.sampleSentence.rawValue)
                }
                
                let dialogues = try await self.fetchDialogues(for: wordRecord)
                
                return Word(
                    id: id,
                    word: word,
                    meaning: meaning,
                    pronunciation: pronunciation,
                    sampleSentence: sampleSentence,
                    sampleDialogue: dialogues
                )
            }
            
            print("[CloudKitFetcher] 단어 조회 완료 - 총 \(words.count)개")
            
            return words
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func fetchDialogues(for wordRecord: CKRecord) async throws -> [Dialogue] {
        do{
            let dialogueRecords = try await fetchRecords(
                recordType: CloudKitType.dialogueRecordType,
                predicate: NSPredicate(format: "\(CloudKitField.wordReference.rawValue) == %@", wordRecord),
                sortBy: "\(CloudKitField.id.rawValue)"
            )
            
            let dialogues: [Dialogue] = try dialogueRecords.map { dialogueRecord in
                guard let id = dialogueRecord[CloudKitField.id.rawValue] as? Int64 else {
                    throw CloudKitError.missingField(field: CloudKitField.id.rawValue)
                }
                guard let sentence = dialogueRecord[CloudKitField.sentence.rawValue] as? String else {
                    throw CloudKitError.missingField(field: CloudKitField.sentence.rawValue)
                }
                guard let speakerType = dialogueRecord[CloudKitField.speakerType.rawValue] as? Int64 else {
                    throw CloudKitError.missingField(field: CloudKitField.speakerType.rawValue)
                }
                
                return Dialogue(
                    id: id,
                    speakerType: speakerType,
                    sentence: sentence
                )
            }
            
            print("[CloudKitFetcher] 대화문 조회 완료 - 총 \(dialogues.count)개")
            
            return dialogues
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
    
    private func processRecordsConcurrently<T>(_ records: [CKRecord], transform: @escaping (CKRecord) async throws -> T) async throws -> [T] {
        do{
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
        } catch {
            throw CloudKitError.invalidData(error.localizedDescription)
        }
    }
}
