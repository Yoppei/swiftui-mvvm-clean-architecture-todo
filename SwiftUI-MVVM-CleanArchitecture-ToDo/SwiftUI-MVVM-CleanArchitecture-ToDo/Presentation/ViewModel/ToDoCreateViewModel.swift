//
//  ToDoCreateViewModel.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/15.
//

import Foundation

final class ToDoCreateViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var note: String = ""
    @Published var dueDate: Date = Date()
    @Published var hasDueDate: Bool = true
    @Published var showActionSheet: Bool = false
    @Published var errorMessage: String?
    
    func saveTask(dismiss: @escaping () -> Void) {        
        do {
            let task = try TaskEntity(title: title, note: note, dueDate: hasDueDate ? dueDate : nil)
            try AppDependency.shared.taskUseCase.saveTask(task)
            dismiss()
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
