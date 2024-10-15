//
//  TaskEntity.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/09.
//

import Foundation

final class TaskEntity: Identifiable, ObservableObject {
    
    private(set) var id: UUID
    private(set) var title: TaskTitleValueObject
    private(set) var note: TaskNoteValueObject
    private(set) var dueDate: TaskDueDateValueObject
    @Published var isDone: Bool
    private(set) var createdAt: Date
    private(set) var updatedAt: Date
    
    // MARK: 初期化init
    init(
        id: UUID = UUID(),
        title: String,
        note: String,
        dueDate: Date? = nil,
        isDone: Bool = false
    ) throws {      
        self.id = id
        self.title = try TaskTitleValueObject(title)
        self.note = TaskNoteValueObject(note)
        
        self.dueDate = try TaskDueDateValueObject(dueDate)
        self.isDone = isDone
        
        let currentTimestamp = Date()
        
        self.createdAt = currentTimestamp
        self.updatedAt = currentTimestamp
    }
    
    // MARK: 再構成用init
    init(
        id: UUID?,
        title: String?,
        note: String?,
        dueDate: Date?,
        isDone: Bool?,
        createdAt: Date?,
        updatedAt: Date?
    ) throws {
        
        guard let id else {
            throw Error.argumumentNilError("id")
        }
        
        guard let title else {
            throw Error.argumumentNilError("title")
        }
        
        guard let note else {
            throw Error.argumumentNilError("note")
        }
        
        guard let isDone else {
            throw Error.argumumentNilError("isDone")
        }
        
        guard let createdAt else {
            throw Error.argumumentNilError("createdAt")
        }
        
        guard let updatedAt else {
            throw Error.argumumentNilError("updatedAt")
        }
        
        self.id = id
        self.title = try TaskTitleValueObject(title)
        self.note = TaskNoteValueObject(note)
        self.dueDate = try TaskDueDateValueObject(dueDate)
        self.isDone = isDone
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(TaskTitleValueObject.self, forKey: .title)
        note = try container.decode(TaskNoteValueObject.self, forKey: .note)
        dueDate = try container.decode(TaskDueDateValueObject.self, forKey: .dueDate)
        isDone = try container.decode(Bool.self, forKey: .isDone)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func setTitleTo(_ title: String) throws {
        self.title = try TaskTitleValueObject(title)
        self.setUpdatedAt()
    }
    
    func setNoteTo(_ note: String) {
        self.note = TaskNoteValueObject(note)
        self.setUpdatedAt()
    }
    
    func setDueDateTo(_ dueDate: Date?) throws {
        self.dueDate = try TaskDueDateValueObject(dueDate)
        self.setUpdatedAt()
    }
    
    func toggleIsDone() {
        self.isDone.toggle()
    }
    
    private func setUpdatedAt() {
        self.updatedAt = Date()
    }
    
    var formattedDueDate: String? {
        guard let dueDate = dueDate.value else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.timeZone = .autoupdatingCurrent
        
        return dateFormatter.string(from: dueDate)
    }
    
    var dateFormatterForTimestamp: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.timeZone = .autoupdatingCurrent
        
        return dateFormatter
    }
    
    
}

// MARK: - Equatable
extension TaskEntity: Equatable {
    
    static func == (lhs: TaskEntity, rhs: TaskEntity) -> Bool {
        lhs.id == rhs.id
    }
    
}

// MARK: - Codable
extension TaskEntity: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case note
        case dueDate
        case isDone
        case createdAt
        case updatedAt
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(note, forKey: .note)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(isDone, forKey: .isDone)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
    
}

// MARK: - Error

extension TaskEntity {
    
    enum Error: LocalizedError, Equatable {
        case argumumentNilError(String)
        
        var errorDescription: String? {
            switch self {
            case .argumumentNilError(let argument):
                return "Argument \(argument) is nil."
            }
        }
    }
    
}
