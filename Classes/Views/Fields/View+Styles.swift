//
//  SwiftUIView.swift
//  
//
//  Created by Nathan Glenn on 7/22/24.
//

import SwiftUI

extension View {
    
    func fontValue(for field: FBField?, with colorScheme: ColorScheme) -> Font {
        if  (field?.style(colorScheme: colorScheme) == nil) {
            print("\(field?.id ?? "") has no style...")
        }
        return Font(field?.style(colorScheme: colorScheme)?.font ?? UIFont.systemFont(ofSize: 17.0))
    }
    
    func colorValue(of attribute: String, for field: FBField?, with colorScheme: ColorScheme) -> Color {
        return Color(hex: field?.style(colorScheme: colorScheme)?.value(forKey: attribute) as? String ?? "FFffffff")
    }
    
    func floatValue(of attribute: String, for field: FBField?, with colorScheme: ColorScheme) -> CGFloat? {
        return field?.style(colorScheme: colorScheme)?.value(forKey: attribute) as? CGFloat
    }
}
