//
//  FetchAllTasksUseCaseTests.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDoTests
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Testing
@testable import SwiftUI_MVVM_CleanArchitecture_ToDo
import Swinject

final class FetchAllTasksUseCaseTests {

    let container: Container = Container()
    let taskRepositoryWithStub: TaskRepositoryStub = TaskRepositoryStub()

    init() {
        container.register(TaskUseCaseProtocol.self) { _ in
            TaskUseCase(
                taskRepository: self.taskRepositoryWithStub
            )
        }
    }
    
    @Test func fetchAllTasksWithStub() throws {
        let useCase = container.resolve(TaskUseCaseProtocol.self)!
        
        let results = try useCase.fetchAllTasks()
        #expect(results.isEmpty == false)
    }
}
