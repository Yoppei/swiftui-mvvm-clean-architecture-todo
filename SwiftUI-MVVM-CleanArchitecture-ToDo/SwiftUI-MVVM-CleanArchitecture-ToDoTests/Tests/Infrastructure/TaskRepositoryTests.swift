//
//  TaskRepositoryTests.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDoTests
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Testing
@testable import SwiftUI_MVVM_CleanArchitecture_ToDo
import CoreData
import Swinject

@Suite(.serialized)
final class TaskRepositoryTests {
    
    @Suite("Create")
    final class CreateTests {
        
        private let repository: TaskRepositoryProtocol
        
        init() {
            let container = Container()
            
            container.register(TaskRepositoryProtocol.self) { _ in TaskRepository(CoreDataManager.shared.viewContext) }
            
            repository = container.resolve(TaskRepositoryProtocol.self)!
        }
        
        @Test func CoreDataにTaskオブジェクトが作成される() throws {
            let task = try TaskEntity(title: "hoge", note: "fuga", dueDate: Date())
            #expect(throws: Never.self) {
                try repository.create(task)
            }
        }
        
    }
    
    @Suite("Fetch")
    final class FetchTests {
        
        private let repository: TaskRepositoryProtocol
        private let tasks = [
            try! TaskEntity(title: "hoge", note: "fuga", dueDate: Date()),
            try! TaskEntity(title: "fuga", note: "hoge", dueDate: Date())
        ]
        
        init() {
            let container = Container()
            
            container.register(TaskRepositoryProtocol.self) { _ in TaskRepository(CoreDataManager.shared.viewContext) }
            
            repository = container.resolve(TaskRepositoryProtocol.self)!
            
            try! tasks.forEach {
                try repository.create($0)
            }
        }
        
        deinit {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try! CoreDataManager.shared.viewContext.execute(batchDeleteRequest)
        }
        
        @Test func CoreDataから指定のTaskオブジェクトを取得する() throws {
            let fetchedTask = try repository.fetchById(tasks[0].id)
            let uwFetchedTask = try #require(fetchedTask)
            #expect(tasks[0].id == uwFetchedTask.id)
        }
        
        @Test func CoreDataからすべてのTaskオブジェクトを取得する() throws {
            let fetchedTasks = try repository.fetchAll()
            #expect(fetchedTasks == tasks)
        }
        
    }
    
    @Suite("Update")
    final class UpdateTests {
        
        private let repository: TaskRepositoryProtocol
        private let tasks = [
            try! TaskEntity(title: "hoge", note: "fuga", dueDate: Date()),
            try! TaskEntity(title: "fuga", note: "hoge", dueDate: Date())
        ]
        
        init() {
            let container = Container()
            
            container.register(TaskRepositoryProtocol.self) { _ in TaskRepository(CoreDataManager.shared.viewContext) }
            
            repository = container.resolve(TaskRepositoryProtocol.self)!
            
            try! tasks.forEach {
                try repository.create($0)
            }
        }
        
        deinit {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try! CoreDataManager.shared.viewContext.execute(batchDeleteRequest)
        }
        
        @Test func CoreDataの指定のTaskオブジェクトを更新する() throws {
            let newTitle = "hogehoge"
            try tasks[0].setTitleTo(newTitle)
            try repository.update(tasks[0])
            #expect(tasks[0].title.value == newTitle)
        }
    }
    
    @Suite("Delete")
    final class DeleteTests {
        
        private let repository: TaskRepositoryProtocol
        private let tasks = [
            try! TaskEntity(title: "hoge", note: "fuga", dueDate: Date()),
            try! TaskEntity(title: "fuga", note: "hoge", dueDate: Date())
        ]
        
        init() {
            let container = Container()
            
            container.register(TaskRepositoryProtocol.self) { _ in TaskRepository(CoreDataManager.shared.viewContext) }
            
            repository = container.resolve(TaskRepositoryProtocol.self)!
            
            try! tasks.forEach {
                try repository.create($0)
            }
        }
        
        deinit {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try! CoreDataManager.shared.viewContext.execute(batchDeleteRequest)
        }
        
        @Test func CoreDataの指定のTaskオブジェクトを削除する() throws {
            #expect(throws: Never.self) {
                try repository.delete(tasks[0])
            }
        }
        
    }

}

extension TaskRepositoryTests {
    
    final class CoreDataManager {
        
        static let shared = CoreDataManager()
        private(set) lazy var persistentContainer: NSPersistentContainer = PersistenceController(inMemory: true).container
        private(set) lazy var viewContext = persistentContainer.viewContext
        
        private init() {}
    }
    
}
