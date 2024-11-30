//
//  LineView.swift
//
//
//  Created by Nathan Glenn on 9/29/23.
//

import SwiftUI

public struct LineView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    @ObservedObject var line:FBLine
    
    public var body: some View {
        
        HStack(spacing: 0) {
            ForEach (line.visibleFields) { field in
                VStack {
                    FieldView(with: field)
                        .border(.black, width: self.borderWidth(field: field))
                        .frame(minWidth: .none, maxWidth: (self.line.section?.form?.width ?? 0.0) / CGFloat(self.line.fields.count), minHeight: .none, maxHeight: .infinity)
                }
                .background(currentColor())
            }
        }
    }

    func currentColor() -> Color {
        
        return line.section?.colorFor(line: line, darkMode: colorScheme == .dark) ?? Color.white
    }
    
    public init(with line:FBLine) {
        
        self.line = line
    }
}

/*
 #Preview {
 LineView(with: nil)
 }
*/
