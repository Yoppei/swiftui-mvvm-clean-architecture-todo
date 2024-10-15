//
//  SwiftUI_MVVM_CleanArchitecture_ToDoApp.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/10.
//

import SwiftUI

@main
struct SwiftUI_MVVM_CleanArchitecture_ToDoApp: App {
    @StateObject private var router: Router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ToDoView()
                    .navigationTitle("一覧")
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .taskDetail(let task):
                            ToDoDetailView(task: task)
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
