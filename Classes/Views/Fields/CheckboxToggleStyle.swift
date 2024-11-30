//
//  CheckboxToggleStyle.swift
//
//
//  Created by Nathan Glenn on 12/20/23.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    func makeBody(configuration: Configuration) -> some View {
        HStack {
 
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .background(backgroundColor())
                .cornerRadius(5.0)
                .overlay {
                    Image(systemName: configuration.isOn ? "checkmark" : "")
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
 
            configuration.label
 
        }
    }
    
    func backgroundColor() -> Color {
        if colorScheme == .dark {
            return .black
        } else {
            return .white
        }
    }
}
