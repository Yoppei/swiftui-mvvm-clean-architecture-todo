//
//  UpdateTaskUseCaseTests.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDoTests
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Testing
@testable import SwiftUI_MVVM_CleanArchitecture_ToDo
import Swinject

final class UpdateTaskUseCaseTests {

    let container: Container = Container()
    let taskRepositoryWithSpy: TaskRepositorySpy = TaskRepositorySpy()
    
    init() {
        container.register(TaskUseCaseProtocol.self) { _ in
            TaskUseCase(
                taskRepository: self.taskRepositoryWithSpy
            )
        }
    }
    
    @Test func updateTaskWithSpy() throws {
        let useCase = container.resolve(TaskUseCaseProtocol.self)!
        
        let task = try TaskEntity(title: "hoge", note: "fuga")
        try! useCase.updateTask(task)
        
        #expect(taskRepositoryWithSpy.receivedTasks.first == task)
        #expect(taskRepositoryWithSpy.calledCount == 1)
    }
    

}
