//
//  DatePickerView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI

struct DatePickerView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    @State var date:Date
    var field:FBDatePickerField? = nil
    
    var body: some View {
        HStack {
            Text(field?.caption ?? "")
                .font(font())
                .padding(EdgeInsets(top: topMargin(),
                                    leading: leftMargin(),
                                    bottom: bottomMargin(),
                                    trailing: rightMargin()))
            Spacer()
            DatePicker(selection: $date, displayedComponents: dateComponents(for: field?.dateType ?? .Date)) {
                
            }
            .onChange(of: date, { oldValue, newValue in
                field?.input = newValue
            })
            .onAppear() {
                field?.input = date
            }
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
        
    func dateComponents(for type: FBDateType) -> DatePickerComponents {
        switch type {
        case .Date:
            return .date
        case .Time:
            return .hourAndMinute
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
}

#Preview {
    DatePickerView(date: Date())
}
