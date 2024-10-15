//
//  Router.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/14.
//

import SwiftUI

final class Router: ObservableObject {
    
    enum Destination: Codable, Hashable {
        case taskDetail(TaskEntity)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .taskDetail(let taskEntity):
                hasher.combine(taskEntity.id)
            }
        }
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigatedToRoot() {
        navPath.removeLast(navPath.count)
    }
    
}
