//
//  ToDoRowView.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/12.
//

import SwiftUI

struct ToDoRowView: View {
    
    let viewData: TaskEntity
    let isDoneTapped: () -> Void
    let action: () -> Void
    
    init(_ task: TaskEntity, isDoneTapped: @escaping () -> Void, action: @escaping () -> Void) {
        self.viewData = task
        self.isDoneTapped = isDoneTapped
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: viewData.isDone ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 32, height: 32)
                .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
                .onTapGesture {
                    isDoneTapped()
                }
            Button {
                action()
            } label: {
                VStack(alignment: .leading) {
                    Text(viewData.title.value)
                        .font(.title2)
                    if let dueDate = viewData.formattedDueDate {
                        Text(dueDate)
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .tint(.black)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.white)
                .shadow(radius: 4)
        }
        
    }
}
