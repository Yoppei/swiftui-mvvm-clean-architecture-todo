//
//  TaskNoteValueObjectTests.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDoTests
//
//  Created by Yohei Okawa on 2024/10/10.
//

import Testing
@testable import SwiftUI_MVVM_CleanArchitecture_ToDo

struct TaskNoteValueObjectTests {

    @Test func 入力値の前後に空白がある場合は空白を削除() {
        let note = TaskNoteValueObject(" hoge ")
        #expect(note.value == "hoge")
    }

}
