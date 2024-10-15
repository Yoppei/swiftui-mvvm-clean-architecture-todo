//
//  TaskEntityTests.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDoTests
//
//  Created by Yohei Okawa on 2024/10/09.
//

import Testing
@testable import SwiftUI_MVVM_CleanArchitecture_ToDo
import Foundation

struct TaskEntityTests {
    
    @Test(.tags(.invalidInput)) func titleは前後の空白を除き20文字を超える場合エラーが発生する() {
        #expect(throws: TaskTitleValueObject.Error.titleTooLong) {
            try TaskEntity(title: " hoge1 hoge2 hoge3 hog ", note: "hoge")
        }
    }
    
    @Test(.tags(.invalidInput)) func titleは前後の空白を除き0文字の場合エラーが発生する() {
        #expect(throws: TaskTitleValueObject.Error.titleTooShort) {
            try TaskEntity(title: "", note: "hoge")
        }
    }
    
    @Test(.tags(.invalidInput)) func dueDateをセットする際に今日より前の日付を設定するとエラーが発生する() {
        #expect(throws: TaskDueDateValueObject.Error.dueDateInPast) {
            try TaskEntity(title: "hoge", note: "hoge", dueDate: Date(timeIntervalSinceNow: -60*60*48))
        }
    }
    
    @Test func titleが正常に変更される() throws {
        let task = try TaskEntity(title: "hoge", note: "")
        try task.setTitleTo("fuga")
        #expect(task.title.value == "fuga")
    }
    
    @Test func noteが正常に変更される() throws {
        let task = try TaskEntity(title: "hoge", note: "")
        task.setNoteTo("fuga")
        #expect(task.note.value == "fuga")
    }
    
    @Test func isDoneが正常に更新される() throws {
        let task = try TaskEntity(title: "hoge", note: "hoge")
        task.toggleIsDone()
        #expect(task.isDone == true)
    }
    
    @Suite("再構成時のinvalid input", .tags(.invalidInput))
    struct ReconstructTests {
        @Test func TaskEntityを再構成時にidがnilの場合Errorが出力される() throws {
            #expect(throws: TaskEntity.Error.argumumentNilError("id")) {
                try TaskEntity(id: nil, title: "hoge", note: "hoge", dueDate: nil, isDone: false, createdAt: Date(), updatedAt: Date())
            }
            
        }
        
        @Test func TaskEntityを再構成時にtitleがnilの場合Errorが出力される() throws {
            #expect(throws: TaskEntity.Error.argumumentNilError("title")) {
                try TaskEntity(id: UUID(), title: nil, note: "hoge", dueDate: nil, isDone: false, createdAt: Date(), updatedAt: Date())
            }
        }
        
        @Test func TaskEntityを再構成時にnoteがnilの場合Errorが出力される() throws {
            #expect(throws: TaskEntity.Error.argumumentNilError("note")) {
                try TaskEntity(id: UUID(), title: "hoge", note: nil, dueDate: nil, isDone: false, createdAt: Date(), updatedAt: Date())
            }
        }
        
        @Test func TaskEntityを再構成時にisDoneがnilの場合Errorが出力される() throws {
            #expect(throws: TaskEntity.Error.argumumentNilError("isDone")) {
                try TaskEntity(id: UUID(), title: "hoge", note: "hoge", dueDate: nil, isDone: nil, createdAt: Date(), updatedAt: Date())
            }
        }
        
        @Test func TaskEntityを再構成時にcreatedAtがnilの場合Errorが出力される() throws {
            #expect(throws: TaskEntity.Error.argumumentNilError("createdAt")) {
                try TaskEntity(id: UUID(), title: "hoge", note: "hoge", dueDate: nil, isDone: false, createdAt: nil, updatedAt: Date())
            }
        }
        
        @Test func TaskEntityを再構成時にupdatedAtがnilの場合Errorが出力される() throws {
            #expect(throws: TaskEntity.Error.argumumentNilError("updatedAt")) {
                try TaskEntity(id: UUID(), title: "hoge", note: "hoge", dueDate: nil, isDone: false, createdAt: Date(), updatedAt: nil)
            }
        }
        
        @Test func TaskEntityを再構成時にargumentNilErrorが発生した場合エラー内容を取得できる() throws {
            do {
                _ = try TaskEntity(id: UUID(), title: "hoge", note: "hoge", dueDate: nil, isDone: false, createdAt: Date(), updatedAt: nil)
            } catch {
                #expect(error.localizedDescription == "Argument updatedAt is nil.")
            }
        }
    }
    
    

}


