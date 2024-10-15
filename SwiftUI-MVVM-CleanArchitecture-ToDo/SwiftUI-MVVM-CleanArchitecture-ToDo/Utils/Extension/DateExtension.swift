//
//  DateExtension.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/15.
//

import Foundation

extension Date {
    
    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        return formatter.string(from: self)
    }
    
}
