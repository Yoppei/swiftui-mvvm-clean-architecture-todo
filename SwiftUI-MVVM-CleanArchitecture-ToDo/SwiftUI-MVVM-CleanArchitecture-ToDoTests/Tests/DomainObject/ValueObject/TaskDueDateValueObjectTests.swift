//
//  TaskDueDateValueObjectTests.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDoTests
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Testing
@testable import SwiftUI_MVVM_CleanArchitecture_ToDo
import Foundation

struct TaskDueDateValueObjectTests {

    @Suite("invalid input", .tags(.invalidInput))
    struct InvalidInputTests {
        @Test func 入力値をセットする際に今日より前の日付を設定するとエラーが発生する() {
            #expect(throws: TaskDueDateValueObject.Error.dueDateInPast) {
                try TaskDueDateValueObject(Date(timeIntervalSinceNow: -60*60*48))
            }
        }
        
        @Test func 入力値をセットする際に今日より前の日付を設定するとエラーが発生しlocalizedDescriptionを取得できる() {
            do {
                let _ = try TaskDueDateValueObject(Date(timeIntervalSinceNow: -60*60*48))
            } catch {
                #expect(error.localizedDescription == TaskDueDateValueObject.Error.dueDateInPast.errorDescription)
            }
        }
    }
    
}
