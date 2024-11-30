//
//  SwitchView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI

struct SwitchView: View {
    
    @Environment(\.styleName) var styleName

    var field:FBSwitchField? = nil

    var labelHeight:CGFloat
    {
        get
        {
            return self.field?.captionHeight() ?? 100.0
        }
    }

    var body: some View {
        Text("Switch View")
    }
}

#Preview {
    SwitchView()
}
