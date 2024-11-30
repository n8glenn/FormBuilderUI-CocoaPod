//
//  CheckBoxView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI

struct CheckBoxView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    var field:FBCheckBoxField? = nil
    @State private var isChecked:Bool = false
    
    var body: some View {
        HStack {
            Toggle(isOn: $isChecked) {
                Text(field?.caption ?? "")
                    .font(font())
                    .foregroundColor(foreground())
            }
            .toggleStyle(CheckboxToggleStyle())
            .onChange(of: isChecked, { oldValue, newValue in
                //print(newValue)
                self.field?.input = newValue
            })
            .padding(EdgeInsets(top: topMargin(),
                                leading: leftMargin(),
                                bottom: bottomMargin(),
                                trailing: rightMargin()))

            Spacer()
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
}

#Preview {
    CheckBoxView()
}
