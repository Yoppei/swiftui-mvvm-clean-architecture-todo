//
//  TaskTitleValueObjectTests.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDoTests
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Testing
@testable import SwiftUI_MVVM_CleanArchitecture_ToDo

struct TaskTitleValueObjectTests {
    
    @Test func 入力値の前後に空白がある場合は空白を削除() {
        let title = try? TaskTitleValueObject(" hoge ")
        #expect(title?.value == "hoge")
    }

    @Suite("invalid input", .tags(.invalidInput))
    struct InvalidInputTests {
        @Test func 入力値が前後の空白を除き20文字を超える場合エラーが発生する() {
            #expect(throws: TaskTitleValueObject.Error.titleTooLong) {
                try TaskTitleValueObject(String(repeating: " a ", count: 8))
            }
        }
        
        @Test func 入力値が前後の空白を除き20文字を超える場合localizedDescriptionを取得できる() {
            do {
                let _ = try TaskTitleValueObject(String(repeating: " a ", count: 8))
            } catch {
                #expect(error.localizedDescription == TaskTitleValueObject.Error.titleTooLong.errorDescription)
            }
        }
        
        @Test func 入力値が前後の空白を除き0文字の場合エラーが発生する() {
            #expect(throws: TaskTitleValueObject.Error.titleTooShort) {
                try TaskTitleValueObject(" ")
            }
        }
        
        @Test func 入力値が前後の空白を除き0文字の場合localizedDescriptionを取得できる() {
            do {
                let _ = try TaskTitleValueObject(" ")
            } catch {
                #expect(error.localizedDescription == TaskTitleValueObject.Error.titleTooShort.errorDescription)
            }
        }
    }
    

}
