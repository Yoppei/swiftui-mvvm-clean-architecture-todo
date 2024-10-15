//
//  TaskDueDateValueObject.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/09.
//

import Foundation

struct TaskDueDateValueObject {
    
    private(set) var value: Date?
    
    init(_ value: Date? = nil) throws {
        let currentTimestamp = Date()
        
        if let value, value < Calendar.current.startOfDay(for: currentTimestamp) {
            throw Error.dueDateInPast
        }
        
        self.value = value
    }
    
}

// MARK: - Codable
extension TaskDueDateValueObject: Codable {}

// MARK: - LocalizedError
extension TaskDueDateValueObject {
    
    enum Error: LocalizedError {
        case dueDateInPast
        
        var errorDescription: String? {
            switch self {
            case .dueDateInPast:
                return "Due date cannot be in the past."
            }
        }
    }
    
}
