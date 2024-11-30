//
//  HeadingView.swift
//
//
//  Created by Nathan Glenn on 9/29/23.
//

import SwiftUI

struct HeadingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    var field:FBHeadingField? = nil
    
    var labelHeight:CGFloat
    {
        get
        {
            return field?.captionHeight() ?? 50
        }
    }

    public var body: some View {

        ZStack {
            Text(field?.caption ?? "")
                .font(Font(field?.style(colorScheme: colorScheme)?.font ?? UIFont.systemFont(ofSize: 17.0)))
                .padding(EdgeInsets(top: topMargin(),
                                    leading: leftMargin(),
                                    bottom: bottomMargin(),
                                    trailing: rightMargin()))
                .background(background())
                .foregroundColor(foreground())
        }
    }
    
    init(with field: FBHeadingField?) {
        self.field = field
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
    HeadingView(with: nil)
}
