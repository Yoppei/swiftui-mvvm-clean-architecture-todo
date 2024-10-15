//
//  ToDoViewModel.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/12.
//

import Foundation
import Combine

final class ToDoViewModel: ObservableObject {
    
    @Published var tasks: [TaskEntity] = [] {
        didSet {
            tasks.forEach { task in
                task.objectWillChange
                    .sink { [unowned self] _ in
                        print("Changed")
                        objectWillChange.send()
                    }
                    .store(in: &cancellables)
            }
        }
    }
    @Published var showSheet: Bool = false
    @Published var errorMessage: String?
    var cancellables: Set<AnyCancellable> = []
    
    func onAppear() {
        loadTasks()
    }
    
    func onDismiss() {
        loadTasks()
    }
    
    func toggleIsDone(_ index: Int) {
        tasks[index].toggleIsDone()
        do {
            try AppDependency.shared.taskUseCase.updateTask(tasks[index])
        } catch {
            
        }
    }
    
    private func loadTasks() {
        do {
            tasks = try AppDependency.shared.taskUseCase.fetchAllTasks()
        } catch {
            
        }
    }

}
