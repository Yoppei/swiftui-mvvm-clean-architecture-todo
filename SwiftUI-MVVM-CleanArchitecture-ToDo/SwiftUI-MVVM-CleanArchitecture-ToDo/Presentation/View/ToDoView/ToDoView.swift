//
//  ToDoView.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/12.
//

import SwiftUI

struct ToDoView: View {
    
    @EnvironmentObject private var router: Router
    @StateObject private var vm: ToDoViewModel = ToDoViewModel()
    
    var body: some View {
        ScrollView {
            if let errorMessage = vm.errorMessage {
                ContentUnavailableView("Error", systemImage: "exclamationmark.triangle.fill", description: Text(errorMessage))
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(vm.tasks.indices, id: \.self) { index in
                        ToDoRowView(vm.tasks[index]) {
                            vm.toggleIsDone(index)
                        } action: {
                            router.navigate(to: .taskDetail(vm.tasks[index]))
                        }
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .onAppear {
            vm.onAppear()
        }
        .navigationTitle("一覧")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    vm.showSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $vm.showSheet, onDismiss: vm.onDismiss) {
            ToDoCreateView()
        }
    }
}

#Preview {
    ToDoView()
}
