//
//  TextAreaView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI

struct TextAreaView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    var field:FBTextAreaField? = nil

    @State var textData:String
     
    func width() -> CGFloat {
        if field?.line?.visibleFields.count ?? 0 == 0
        {
            return field?.line?.section?.form?.width ?? 0
        } else {
            return ((field?.line?.section?.form?.width ?? 0) / CGFloat(field?.line?.visibleFields.count ?? 0)) - ((field?.style(colorScheme: colorScheme)?.value(forKey: "margin") as? CGFloat ?? 0) * 2)
        }
    }
    
    func labelHeight() -> CGFloat
    {
        return (self.field?.captionHeight() ?? 30.0)
    }
    
    var body: some View {
        
        VStack {
            Text(field?.caption ?? "")
                .font(font())
                .frame(minWidth: .none, maxWidth: .infinity, minHeight: self.field?.captionHeight() ?? 30.0, maxHeight: .infinity, alignment: .topLeading)
                .padding(EdgeInsets(top: topMargin(),
                                    leading: leftMargin(),
                                    bottom: bottomMargin(),
                                    trailing: rightMargin()))

            HStack(alignment: .center, spacing: 5, content: {
                TextEditor(text: $textData)
                    .border(Color.black, width: 0.5)
                    .textFieldStyle(.roundedBorder)
                    .font(font())
                    .lineLimit(50)
                    .frame(minWidth: .none, maxWidth: .infinity, minHeight: self.field?.dataHeight() ?? 30.0, maxHeight: .infinity)
                    .padding(EdgeInsets(top: topMargin(),
                                        leading: leftMargin(),
                                        bottom: bottomMargin(),
                                        trailing: rightMargin()))
                    .onChange(of: textData, { oldValue, newValue in
                        self.field?.input = newValue
                    })
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.red)
                    .shadow(radius: 2.5)
                    .padding(EdgeInsets(top: topMargin(),
                                        leading: leftMargin(),
                                        bottom: bottomMargin(),
                                        trailing: rightMargin()))
            })
        }
        .frame(minWidth: .none, maxWidth: .infinity, minHeight: .none, maxHeight: .infinity, alignment: .topLeading)
    }
    
    public init(with field:FBTextAreaField?) {
        self.field = field
        self.textData = "\(field?.data ?? "")"
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
    TextAreaView(with: nil)
}
