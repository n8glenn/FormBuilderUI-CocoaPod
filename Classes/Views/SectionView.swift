//
//  SectionView.swift
//  
//
//  Created by Nathan Glenn on 9/29/23.
//

import SwiftUI

public struct SectionView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName
    @ObservedObject var section:FBSection
    private var background:String = "background-color"
    
    public var body: some View {
        
        VStack(spacing: 0) {
            ForEach (section.visibleLines) { line in
                LineView(with: line)
                    .border(.black, width: line.borderWidth())
            }
        }
    }
        
    public init(with section:FBSection) {
        self.section = section
    }
}

/*
#Preview {
    SectionView(with: nil)
}
*/
