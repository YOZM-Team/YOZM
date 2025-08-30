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
    case wordNotFound
    
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
        case .wordNotFound:
            return "단어를 찾을 수 없습니다"
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
            let container = try ModelContainer(for: WordModel.self)
            self.modelContext = ModelContext(container)
        } catch {
            print("ModelContainer 생성 실패: \(error)")
        }
    }
    
    func saveWord(_ word: WordModel) throws {
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        context.insert(word)
        
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.saveError(error)
        }
    }
    
    func fetchAllWords() throws -> [WordModel] {
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        let fetchDescriptor = FetchDescriptor<WordModel>(
            sortBy: [SortDescriptor(\.id)]
        )
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            throw SwiftDataServiceError.fetchError(error)
        }
    }
    
    func fetchWord(by id: Int64) throws -> WordModel {
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        let predicate = #Predicate<WordModel> { word in
            word.id == id
        }
        
        let fetchDescriptor = FetchDescriptor<WordModel>(
            predicate: predicate
        )
        
        do {
            let words = try context.fetch(fetchDescriptor)
            guard let word = words.first else {
                throw SwiftDataServiceError.wordNotFound
            }
            return word
        } catch {
            if error is SwiftDataServiceError {
                throw error
            } else {
                throw SwiftDataServiceError.fetchError(error)
            }
        }
    }
    
    func deleteWord(_ word: WordModel) throws {
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        context.delete(word)
        
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.deleteError(error)
        }
    }
    
    func updateWord(_ word: WordModel, newWord: String) throws {
        word.word = newWord
        
        guard let context = modelContext else {
            throw SwiftDataServiceError.modelContextNotInitialized
        }
        
        do {
            try context.save()
        } catch {
            throw SwiftDataServiceError.saveError(error)
        }
    }
}
