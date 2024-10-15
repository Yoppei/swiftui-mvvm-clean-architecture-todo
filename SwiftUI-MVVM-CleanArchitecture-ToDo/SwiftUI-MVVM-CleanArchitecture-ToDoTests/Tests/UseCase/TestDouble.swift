//
//  TestDouble.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDoTests
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Foundation
@testable import SwiftUI_MVVM_CleanArchitecture_ToDo

final class TaskRepositorySpy: TaskRepositoryProtocol {
    
    private let taskRepository = TaskRepository(PersistenceController(inMemory: true).container.viewContext)
    
    private(set) var receivedTasks: [TaskEntity] = []
    
    var calledCount: Int {
        receivedTasks.count
    }
    
    func create(_ task: TaskEntity) throws {
        receivedTasks.append(task)
        try taskRepository.create(task)
    }
    
    func fetchById(_ id: UUID) throws -> TaskEntity? { return nil }
    
    func fetchAll() throws -> [TaskEntity] { return [] }
    
    func update(_ task: TaskEntity) throws {
        receivedTasks.append(task)
        try taskRepository.update(task)
    }
    
    func delete(_ task: TaskEntity) throws {
        receivedTasks.append(task)
        try taskRepository.delete(task)
    }
    
}

final class TaskRepositoryStub: TaskRepositoryProtocol {
    
    func create(_ task: TaskEntity) throws {
        return
    }
    
    func fetchById(_ id: UUID) throws -> TaskEntity? {
        return try TaskEntity(id: UUID(), title: "hoge", note: "fuga", dueDate: Date(), isDone: false, createdAt: Date(), updatedAt: Date())
    }
    
    func fetchAll() throws -> [TaskEntity] {
        return [
            try TaskEntity(
                id: UUID(),
                title: "hoge",
                note: "fuga",
                dueDate: Date(),
                isDone: false,
                createdAt: Date(),
                updatedAt: Date()
            )
        ]
    }
    
    func update(_ task: TaskEntity) throws {
        return
    }
    
    func delete(_ task: TaskEntity) throws {
        return
    }
    
    
    
    
}
