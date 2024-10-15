//
//  ToDoDetailViewModel.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/14.
//

import Foundation
import Combine

final class ToDoDetailViewModel: ObservableObject {
    
    @Published var task: TaskEntity
    @Published var title: String
    @Published var note: String
    @Published var dueDate: Date?
    @Published var hasDueDate: Bool {
        didSet {
            var toggleOn: Bool { !oldValue && hasDueDate }
            guard toggleOn else { return }
            setDueDate(Date())
        }
    }
    @Published var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(task: TaskEntity) {
        self.task = task
        self.title = task.title.value
        self.note = task.note.value
        self.dueDate = task.dueDate.value
        self.hasDueDate = task.dueDate.value != nil
        
        task
            .objectWillChange
            .sink { [unowned self] _ in
                objectWillChange.send()
            }
            .store(in: &cancellables)
        
        $hasDueDate
            .sink { [unowned self] value in
                if value == false {
                    setDueDate(nil)
                }
            }
            .store(in: &cancellables)
    }
    
    func setNote() {
        task.setNoteTo(note)
        do {
            try AppDependency.shared.taskUseCase.updateTask(task)
        } catch {
            setError(error.localizedDescription)
        }
    }
    
    func setDueDate(_ value: Date?) {
        dueDate = value
        do {
            try task.setDueDateTo(value)
            try AppDependency.shared.taskUseCase.updateTask(task)
        } catch {
            setError(error.localizedDescription)
        }
    }
    
    func toggleIsDone() {
        task.toggleIsDone()
        do {
            try AppDependency.shared.taskUseCase.updateTask(task)
        } catch {
            setError(error.localizedDescription)
        }
    }
    
    func setError(_ errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    func resetError() {
        self.errorMessage = nil
    }
    
}

