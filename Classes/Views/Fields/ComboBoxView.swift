//
//  SwiftUIView.swift
//  
//
//  Created by Nathan Glenn on 9/29/23.
//

import SwiftUI

struct ComboBoxView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    var field:FBComboBoxField? = nil
    @State var selection:String = ""
    
    public var body: some View {
        HStack {
            Text(self.field?.caption ?? "").font(font())
                .padding(EdgeInsets(top: topMargin(),
                                    leading: leftMargin(),
                                    bottom: bottomMargin(),
                                    trailing: rightMargin()))
                .foregroundColor(foreground())
            Spacer()
            Picker(selection: $selection,
                   label: Text(""),
                   content: {
                Text("").tag("")
                ForEach(self.field?.optionSet?.options ?? []) { option in
                    Text(option.value).tag(option.id)
                }
            })
            .accentColor(foreground())
            .background(background())
            .border(foreground())
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selection, { oldValue, newValue in
                //print(newValue)
                self.field?.input = newValue
            })
            .padding(EdgeInsets(top: 0.0, 
                                leading: field?.margin() ?? 0,
                                bottom: 0.0,
                                trailing: field?.margin() ?? 0))
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(.red)
                .shadow(radius: 2.5)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                .opacity(self.field?.required ?? false ? 1.0 : 0.0)
                .padding(EdgeInsets(top: topMargin(),
                                    leading: leftMargin(),
                                    bottom: bottomMargin(),
                                    trailing: rightMargin()))
        }
        .onAppear() {
            if field?.input is String {
                selection = field?.input as? String ?? ""
            }
        }
    }
    
    public init(with field:FBComboBoxField?) {
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
    ComboBoxView(with: nil)
}
