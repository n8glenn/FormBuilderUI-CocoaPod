//
//  LabelView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI

struct LabelView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    @State var refresh: Bool = false

    public func update() {
       refresh.toggle()
    }

    var field:FBLabelField? = nil
    
    var body: some View {
        VStack {
            Text(field?.caption ?? "")
                .font(font())
                .lineLimit(50)
                .frame(minWidth: .none, maxWidth: .infinity, minHeight: self.field?.captionHeight() ?? 30.0, maxHeight: .infinity, alignment: .topLeading)
                .padding(EdgeInsets(top: topMargin(),
                                    leading: leftMargin(),
                                    bottom: bottomMargin(),
                                    trailing: rightMargin()))
            Spacer()
        }
    }
    
    func font() -> Font {
        return fontValue(for: field, with: colorScheme)
    }
    
    public func margin() -> CGFloat {
        return self.field?.margin() ?? 0.0
    }
    
    public func topMargin() -> CGFloat {
        return self.field?.topMargin() ?? 0.0
    }

    public func bottomMargin() -> CGFloat {
        return self.field?.bottomMargin() ?? 0.0
    }

    public func leftMargin() -> CGFloat {
        return self.field?.leftMargin() ?? 0.0
    }

    public func rightMargin() -> CGFloat {
        return self.field?.rightMargin() ?? 0.0
    }

    func foreground() -> Color {
        return colorValue(of: "foreground-color", for: field, with: colorScheme)
    }

    func background() -> Color {
        return colorValue(of: "background-color", for: field, with: colorScheme)
    }
}

#Preview {
    LabelView()
}
