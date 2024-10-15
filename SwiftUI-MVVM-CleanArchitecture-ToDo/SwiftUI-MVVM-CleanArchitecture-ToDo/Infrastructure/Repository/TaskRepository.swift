//
//  TaskRepository.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Foundation
import CoreData
import Combine

protocol TaskRepositoryProtocol {
    
    func create(_ task: TaskEntity) throws
    func fetchById(_ id: UUID) throws -> TaskEntity?
    func fetchAll() throws -> [TaskEntity]
    func update(_ task: TaskEntity) throws
    func delete(_ task: TaskEntity) throws
    
}

final class TaskRepository: TaskRepositoryProtocol {
    
    private let viewContext: NSManagedObjectContext
    
    init(_ viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func create(_ task: TaskEntity) throws {
        let newTask = Task(context: viewContext)
        newTask.id = task.id
        newTask.title = task.title.value
        newTask.note = task.note.value
        newTask.dueDate = task.dueDate.value
        newTask.isDone = task.isDone
        newTask.createdAt = task.createdAt
        newTask.updatedAt = task.updatedAt
        do {
            try viewContext.save()
        } catch {
            throw Error.creationFailed
        }
    }
    
    func fetchById(_ id: UUID) throws -> TaskEntity? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", id as NSUUID
        )
        
        do {
            let task = try viewContext.fetch(fetchRequest).first
            guard let task else {
                return nil
            }
            
            return try TaskEntity(
                id: task.id!,
                title: task.title!,
                note: task.note!,
                dueDate: task.dueDate,
                isDone:task.isDone
            )
        } catch {
            throw Error.fetchingFailed
        }
    }
    
    func fetchAll() throws -> [TaskEntity] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            return try tasks.map { task in
                try TaskEntity(
                    id: task.id!,
                    title: task.title!,
                    note: task.note!,
                    dueDate: task.dueDate,
                    isDone:task.isDone
                )
            }
        } catch {
            throw Error.fetchingFailed
        }
        
    }
    
    func update(_ task: TaskEntity) throws {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", task.id as NSUUID
        )
        let fetchedTask = try viewContext.fetch(fetchRequest).first
        
        guard let fetchedTask else {
            return
        }
        
        fetchedTask.title = task.title.value
        fetchedTask.note = task.note.value
        fetchedTask.dueDate = task.dueDate.value
        fetchedTask.isDone = task.isDone
        fetchedTask.updatedAt = task.updatedAt
        
        do {
            guard viewContext.hasChanges else { return }
            try viewContext.save()
        } catch {
            throw Error.updatingFailed
        }
    }
    
    func delete(_ task: TaskEntity) throws {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@", task.id as NSUUID
        )
        let fetchedTask = try viewContext.fetch(fetchRequest).first
        guard let fetchedTask else { return }
        
        viewContext.delete(fetchedTask)
    }
    
}

extension TaskRepository {
    
    enum Error: LocalizedError {
        case creationFailed
        case fetchingFailed
        case updatingFailed
        case deletingFailed
        
        var errorDescription: String? {
            switch self {
            case .creationFailed: return "Creation failed."
            case .fetchingFailed: return "Fetching failed."
            case .updatingFailed: return "Updating failed."
            case .deletingFailed: return "Deleting failed."
            }
        }
    }
    
}

