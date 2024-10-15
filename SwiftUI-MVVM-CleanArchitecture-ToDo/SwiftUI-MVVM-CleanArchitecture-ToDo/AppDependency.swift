//
//  AppDependency.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/12.
//

import Foundation
import Swinject

final class AppDependency {
    
    static let shared = AppDependency()
    
    let taskRepository: TaskRepositoryProtocol
    let taskUseCase: TaskUseCaseProtocol
    
    let container: Container = Container() { container in
        container.register(TaskRepositoryProtocol.self) { _ in
            TaskRepository(PersistenceController.preview.container.viewContext)
        }
        container.register(TaskUseCaseProtocol.self) { r in
            TaskUseCase(taskRepository: r.resolve(TaskRepositoryProtocol.self)!)
        }
    }
    
    private init () {
        self.taskRepository = self.container.resolve(TaskRepositoryProtocol.self)!
        self.taskUseCase = self.container.resolve(TaskUseCaseProtocol.self)!
    }
    
}
