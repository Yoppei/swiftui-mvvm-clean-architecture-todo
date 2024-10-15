//
//  TaskTitleValueObject.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/09.
//

import Foundation

struct TaskTitleValueObject {
    
    private(set) var value: String
    
    init(_ title: String) throws {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        
        guard trimmedTitle.count <= 20 else {
            throw Error.titleTooLong
        }
        
        guard trimmedTitle.count >= 1 else {
            throw Error.titleTooShort
        }
        
        self.value = trimmedTitle
    }
    
}

// MARK: - Codable
extension TaskTitleValueObject: Codable {}

// MARK: - LocalizedError
extension TaskTitleValueObject {
    
    enum Error: LocalizedError {
        case titleTooLong
        case titleTooShort
        
        var errorDescription: String? {
            switch self {
            case .titleTooLong: "タイトルが長すぎます。"
            case .titleTooShort: "タイトルが短すぎます。"
            }
        }
    }
    
}
