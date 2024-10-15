//
//  ImageExtension.swift
//  SwiftUI-MVVM-CleanArchitecture-ToDo
//
//  Created by Yohei Okawa on 2024/10/14.
//

import SwiftUI

extension Image {
    
    func baseStyle(color: Color, size: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: size, height: size)
            .foregroundStyle(color)
    }
    
}
