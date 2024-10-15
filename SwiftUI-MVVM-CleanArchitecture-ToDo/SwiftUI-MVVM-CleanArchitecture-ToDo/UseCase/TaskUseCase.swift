//
//  TaskUseCase.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Foundation

protocol TaskUseCaseProtocol {
    
    func saveTask(_ task: TaskEntity) throws
    func updateTask(_ task: TaskEntity) throws
    func fetchAllTasks() throws ->  [TaskEntity]
    func deleteTask(_ task: TaskEntity) throws
    
}

struct TaskUseCase: TaskUseCaseProtocol {
    
    let taskRepository: TaskRepositoryProtocol
    
    func saveTask(_ task: TaskEntity) throws {
        try taskRepository.create(task)
    }
    
    func updateTask(_ task: TaskEntity) throws {
        try taskRepository.update(task)
    }
    
    func fetchAllTasks() throws -> [TaskEntity] {
        return try taskRepository.fetchAll()
    }
    
    func deleteTask(_ task: TaskEntity) throws {
        try taskRepository.delete(task)
    }
    
}
