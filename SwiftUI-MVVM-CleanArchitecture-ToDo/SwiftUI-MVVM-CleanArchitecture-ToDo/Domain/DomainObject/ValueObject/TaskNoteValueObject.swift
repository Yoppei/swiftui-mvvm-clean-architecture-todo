//
//  TaskNoteValueObject.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/09.
//

import Foundation

struct TaskNoteValueObject {
    
    private(set) var value: String
    
    init(_ value: String) {
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        self.value = trimmedValue
    }
    
}

extension TaskNoteValueObject: Codable {}
