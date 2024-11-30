//
//  OptionSetView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI

struct ColorInvert: ViewModifier {

    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        Group {
            if colorScheme == .dark {
                content.colorInvert()
            } else {
                content
            }
        }
    }
}

struct RadioButton: View {

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    let id: String
    let field: FBOptionSetField?
    let callback: (String)->()
    let selectedID : String
    
    init(
        _ id: String,
        field: FBOptionSetField?,
        callback: @escaping (String)->(),
        selectedID: String
        ) {
            self.id = id
            self.field = field
            self.selectedID = selectedID
            self.callback = callback
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: self.selectedID == self.id ? "largecircle.fill.circle" : "circle")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20.0, height: 20.0)
                .modifier(ColorInvert())
                .background(Color.white)
                .clipShape(.circle)
            Text(id)
                .font(Font(field?.style(colorScheme: colorScheme)?.font ?? UIFont.systemFont(ofSize: 17.0)))
                .foregroundColor(foreground())
            Spacer()
        }
        .onTapGesture {
            self.callback(self.id)
        }
        .padding(EdgeInsets(top: topMargin(), leading: leftMargin(), bottom: bottomMargin(), trailing: rightMargin()))
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
        return Color(hex: self.field?.style(colorScheme: colorScheme)?.value(forKey: "foreground-color") as? String ?? "ffffffFF")
    }
}

struct RadioButtonGroup: View {

    let field: FBOptionSetField?
    let items : [String]
    var selectedId: String = ""
    let callback: (String) -> ()

    init(field: FBOptionSetField?, items: [String], selectedId: String, callback: @escaping (String) -> ()) {
        self.field = field
        self.items = items
        self.selectedId = selectedId
        self.callback = callback
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<items.count) { index in
                RadioButton(self.items[index], field: self.field, callback: self.callback, selectedID: self.selectedId)
            }
        }
    }
}

struct OptionSetView: View {

    var field:FBOptionSetField? = nil
    @State var selected:String? = nil
    
    var body: some View {
        HStack {
            RadioButtonGroup(field: field, items: field?.optionSet?.optionArray() ?? [],
                             selectedId: self.selected ?? "") { selected in
                //print("Selected is: \(selected)")
                self.selected = selected
                self.field?.input = selected
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
}

#Preview {
    OptionSetView()
}
