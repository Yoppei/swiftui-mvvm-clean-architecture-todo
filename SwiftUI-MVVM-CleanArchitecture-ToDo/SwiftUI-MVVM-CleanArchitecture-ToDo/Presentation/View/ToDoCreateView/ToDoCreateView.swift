//
//  ToDoCreateView.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/15.
//

import SwiftUI

struct ToDoCreateView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm: ToDoCreateViewModel = ToDoCreateViewModel()
    @FocusState private var focusedField: InputField?
    
    enum InputField: Hashable {
        case title
        case note
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 20) {
                        Image(systemName: "textformat")
                            .foregroundStyle(.gray)
                        VStack(alignment: .leading) {
                            TextField(
                                "タイトル",
                                text: $vm.title
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .focused($focusedField, equals: .title)
                        }
                    }
                    HStack(spacing: 20) {
                        Image(systemName: "calendar")
                            .baseStyle(color: .gray, size: 24)
                        VStack(alignment: .leading) {
                            Text("予定日")
                            if vm.hasDueDate {
                                Text(vm.dueDate.formattedDueDate)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            } else {
                                Text("未定")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        Spacer()
                        Toggle("予定日", isOn: $vm.hasDueDate)
                            .labelsHidden()
                    }
                    if vm.hasDueDate {
                        DatePicker(
                            "予定日",
                            selection: $vm.dueDate,
                            in: Date()...,
                            displayedComponents: .date
                        )
                        
                        .datePickerStyle(.graphical)
                        
                    }
                    
                } footer: {
                    if let errorMessage = vm.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                ZStack(alignment: .topLeading) {
                    TextEditor(
                        text: $vm.note
                    )
                    .focused($focusedField, equals: .note)
                    .frame(minHeight: 200)
                    .padding(.horizontal, -4)
                    if vm.note.isEmpty {
                        Text("メモ")
                            .foregroundStyle(.gray)
                            .padding(.vertical, 8)
                            .allowsHitTesting(false)
                    }
                }
            }
            .animation(.default, value: vm.hasDueDate)
            .navigationTitle("タスク作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = .none
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        vm.resetError()
                        vm.saveTask() {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        vm.showActionSheet.toggle()
                        
                    }
                }
            }
            .confirmationDialog("変更の破棄", isPresented: $vm.showActionSheet) {
                Button("破棄する", role: .destructive) {
                    dismiss()
                }
                Button("キャンセル", role: .cancel) {
                    vm.showActionSheet.toggle()
                }
            } message: {
                Text("変更を保存せずに破棄しますか")
            }
        }
    }
}
