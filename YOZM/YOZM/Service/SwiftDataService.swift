//
//  SwiftDataService.swift
//  YOZM
//
//  Created by 정희균 on 8/15/25.
//

import SwiftData
import Foundation

enum SwiftDataServiceError: Error {
    case modelContextNotInitialized
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
    case chapterNotFound
    
    var errorDescription: String {
        switch self {
        case .modelContextNotInitialized:
            return "모델 컨텍스트가 초기화되지 않았습니다"
        case .saveError(let error):
            return "데이터 저장에 실패했습니다: \(error.localizedDescription)"
        case .fetchError(let error):
            return "데이터 조회에 실패했습니다: \(error.localizedDescription)"
        case .deleteError(let error):
            return "데이터 삭제에 실패했습니다: \(error.localizedDescription)"
        case .chapterNotFound:
            return "챕터를 찾을 수 없습니다"
        }
    }
}

final class SwiftDataService {
    static let shared = SwiftDataService()
    
    private var modelContext: ModelContext?
    
    private init() {
        setupModelContainer()
    }
    
    private func setupModelContainer() {
        do {
            let container = try ModelContainer(
                for: ChapterModel.self,
                StageModel.self,
                WordModel.self,
                DialogueModel.self
            )
            self.modelContext = ModelContext(container)
        } catch {
            print("ModelContainer 생성 실패: \(error)")
        }
    }
    
    func saveChapter(_ chapter: Chapter) throws {
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        let chapterModel = ChapterModel(id: chapter.id, title: chapter.title)
        context.insert(chapterModel)
        
        for stage in chapter.stages {
            let stageModel = StageModel(id: stage.id, title: stage.title)
            stageModel.chapter = chapterModel
            context.insert(stageModel)
            
            for word in stage.words {
                let wordModel = WordModel(
                    id: word.id,
                    word: word.word,
                    meaning: word.meaning,
                    pronunciation: word.pronunciation,
                    sampleSentence: word.sampleSentence
                )
                wordModel.stage = stageModel
                context.insert(wordModel)
                
                for dialogue in word.sampleDialogue {
                    let dialogueModel = DialogueModel(
                        id: dialogue.id,
                        speakerType: dialogue.speakerType,
                        sentence: dialogue.sentence
                    )
                    dialogueModel.word = wordModel
                    context.insert(dialogueModel)
                }
            }
        }
        
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.saveError(error)
        }
    }
    
    func fetchAllChapters() throws -> [Chapter] {
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        let fetchDescriptor = FetchDescriptor<ChapterModel>(
            sortBy: [SortDescriptor(\.id)]
        )
        
        do {
            let chapterModels = try context.fetch(fetchDescriptor)
            return chapterModels.map { $0.toChapter() }
        } catch {
            throw SwiftDataServiceError.fetchError(error)
        }
    }
    
    func fetchChapter(by id: Int64) throws -> Chapter {
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        let predicate = #Predicate<ChapterModel> { chapter in
            chapter.id == id
        }
        
        let fetchDescriptor = FetchDescriptor<ChapterModel>(predicate: predicate)
        
        do {
            let chapterModels = try context.fetch(fetchDescriptor)
            guard let chapterModel = chapterModels.first else {
                throw SwiftDataServiceError.chapterNotFound
            }
            return chapterModel.toChapter()
        } catch {
            throw SwiftDataServiceError.fetchError(error)
        }
    }
    
    func clearAllData() throws {
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        do {
            try context.delete(model: DialogueModel.self)
            try context.delete(model: WordModel.self)
            try context.delete(model: StageModel.self)
            try context.delete(model: ChapterModel.self)
            try context.save()
        } catch {
            throw SwiftDataServiceError.deleteError(error)
        }
    }
}
