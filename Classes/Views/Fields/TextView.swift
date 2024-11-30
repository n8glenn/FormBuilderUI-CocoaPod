//
//  TextView.swift
//
//
//  Created by Nathan Glenn on 9/29/23.
//

import SwiftUI

public struct TextView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    @State var refresh:Bool = false 
    var field:FBTextField? = nil
    @State var textData:String

    var height:CGFloat
    {
        get
        {
            let size = sizeOfString(string: field?.caption ?? "", constrainedToWidth: self.width - (field?.style()?.value(forKey: "margin") as? CGFloat ?? 0) * 2)
            let height = size.height + ((field?.style(colorScheme: colorScheme)?.value(forKey: "margin") as? CGFloat ?? 0) * 2)
            if (height < field?.style()?.value(forKey: "height") as? CGFloat ?? 30.0)
            {
                return field?.style()?.value(forKey: "height") as? CGFloat ?? 30.0
            }
            else
            {
                return height
            }
        }
    }
    
    var width:CGFloat
    {
        get
        {
            if field?.line?.visibleFields.count ?? 0 == 0
            {
                return field?.line?.section?.form?.width ?? 0.0
            } else {
                return (field?.line?.section?.form?.width ?? 0 / CGFloat(field?.line?.visibleFields.count ?? 1)) - ((field?.style()?.value(forKey: "margin") as? CGFloat ?? 0.0) * 2)
            }
        }
    }
    
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: field?.style(colorScheme: colorScheme)?.font ?? UIFont.systemFont(ofSize: 17)],
            context: nil).size
    }
    
    var labelHeight:CGFloat
    {
        get
        {
            return self.field?.captionHeight() ?? 50.0
        }
    }
    
    var labelWidth:CGFloat
    {
        get
        {
            return 0.0
        }
    }

    public func dataChanged(data: Any?) {
        textData = String(describing: data)
    }
    
    public var body: some View {
        HStack {
            Text(self.field?.caption ?? "")
                .font(font())
            TextField("", text: $textData)
                .border(Color.black, width: 0.5)
                .textFieldStyle(.roundedBorder)
                .font(font())
                .onChange(of: textData, { oldValue, newValue in
                    self.field?.input = newValue
                })
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(.red)
                .shadow(radius: 2.5)
                .opacity(self.field?.required ?? false ? 1.0 : 0.0)
                .padding(EdgeInsets(top: topMargin(),
                                    leading: leftMargin(),
                                    bottom: bottomMargin(),
                                    trailing: rightMargin()))
        }
        .padding(EdgeInsets(top: topMargin(),
                            leading: leftMargin(),
                            bottom: bottomMargin(),
                            trailing: rightMargin()))
    }
    
    public init(with field:FBTextField?) {
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
    TextView(with: nil)
}
