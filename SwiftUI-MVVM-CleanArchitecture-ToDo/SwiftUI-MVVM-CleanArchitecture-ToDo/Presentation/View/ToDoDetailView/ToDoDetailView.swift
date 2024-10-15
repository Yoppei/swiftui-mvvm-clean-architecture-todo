//
//  ToDoDetailView.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/14.
//

import SwiftUI

struct ToDoDetailView: View {
    
    @EnvironmentObject var router: Router
    
    @StateObject private var vm: ToDoDetailViewModel
    @FocusState private var focusedField: InputField?
    
    enum InputField: Hashable {
        case title
        case note
    }
    
    init(task: TaskEntity) {
        self._vm = StateObject(
            wrappedValue: ToDoDetailViewModel(task: task)
        )
    }
    
    var body: some View {
        Form {
            Section {
                HStack(spacing: 20) {
                    Image(systemName: vm.task.isDone ? "checkmark.circle.fill" : "circle")
                        .baseStyle(color: .gray, size: 24)
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
                        .onTapGesture {
                            vm.toggleIsDone()
                        }
                    VStack(alignment: .leading) {
                        TextField(
                            "タイトル",
                            text: $vm.title
                        )
                        .onSubmit {
                            do {
                                try vm.task.setTitleTo(vm.title)
                                vm.resetError()
                            } catch {
                                vm.setError(error.localizedDescription)
                            }
                        }
                        .focused($focusedField, equals: .title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                HStack(spacing: 20) {
                    Image(systemName: "calendar")
                        .baseStyle(color: .gray, size: 24)
                    VStack(alignment: .leading) {
                        Text("予定日")
                        if let dueDate = vm.task.dueDate.value, vm.hasDueDate {
                            Text(dueDate.formattedDueDate)
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
                if let dueDate = vm.dueDate, vm.hasDueDate {
                    DatePicker(
                        "予定日",
                        selection: Binding(get: {
                            dueDate
                        }, set: { newValue in
                            vm.setDueDate(newValue)
                        }),
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
                .frame(minHeight: 200)
                .focused($focusedField, equals: .note)
                .padding(.horizontal, -4)
                if vm.note.isEmpty {
                    Text("メモ")
                        .foregroundStyle(.gray)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }
            }
            .onChange(of: focusedField) { oldValue, newValue in
                var noteIsSubmitted: Bool {
                    oldValue == .note && newValue == .none
                }
                
                guard noteIsSubmitted else { return }
                vm.setNote()
            }
            Section {
                Button("削除", role: .destructive) {
                    vm.deleteTask()
                    router.navigateBack()
                }
            }
            
        }
        .animation(.default, value: vm.hasDueDate)
        .navigationTitle(vm.task.title.value)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleMenu {
            Section("作成日時") {
                Text(vm.task.dateFormatterForTimestamp.string(from: vm.task.createdAt))
                    .tint(.black)
            }
            Section("更新日時") {
                Text(vm.task.dateFormatterForTimestamp.string(from: vm.task.updatedAt))
                    .foregroundStyle(.black)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = .none
                }
            }
        }
    }
}


#Preview {
    
    let task = try! TaskEntity(title: "hoge", note: "", dueDate: Date())
    NavigationStack {
        ToDoDetailView(task: task)
    }
}
