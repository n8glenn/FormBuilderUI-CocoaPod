//
//  FieldView.swift
//
//
//  Created by Nathan Glenn on 9/29/23.
//

import SwiftUI

struct FieldView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    @ObservedObject var field:FBField
    
    public var body: some View {
        HStack {
            switch field.fieldType {
            case .Label:
                LabelView(field: field as? FBLabelField)
                    .frame(minWidth: .none, 
                           maxWidth: .infinity,
                           minHeight:field.line?.height() ?? 0,
                           maxHeight: .infinity)
                
            case .Text:
                TextView(with: field as? FBTextField)
                    .frame(minWidth: .none, 
                           maxWidth: .none,
                           minHeight: field.line?.height() ?? 0,
                           maxHeight: .infinity)
            case .CheckBox:
                CheckBoxView(field: field as? FBCheckBoxField)
                    .frame(minWidth: .none,
                           maxWidth: .none,
                           minHeight: field.line?.height() ?? 0,
                           maxHeight: .infinity)
            case .ComboBox:
                ComboBoxView(with: field as? FBComboBoxField)
            case .DatePicker:
                DatePickerView(date: Date(), field: field as? FBDatePickerField)
            case .Heading:
                HeadingView(with: field as? FBHeadingField)
                    .frame(minWidth: self.width(field: field), 
                           maxWidth: .infinity,
                           minHeight: field.line?.height() ?? 0,
                           maxHeight: .infinity)
                    .background(background(for: field as? FBHeadingField))
            case .Image:
                ImageView(field: field as? FBImageField)
                    //.frame(minWidth: .none, maxWidth: self.width(field: field), minHeight: field?.line?.height(), maxHeight: .infinity)
            case .ImagePicker:
                ImagePickerView(field: field as? FBImagePickerField)
                    //.frame(minWidth: .none, maxWidth: self.width(field: field), minHeight: field?.line?.height(), maxHeight: .infinity)
            case .OptionSet:
                OptionSetView(field: field as? FBOptionSetField)
                    //.frame(minWidth: .none, maxWidth: self.width(field: field), minHeight: field?.line?.height(), maxHeight: .infinity)
            case .Signature:
                SignatureView(field: field as? FBSignatureField)
                    .frame(minWidth: .none,
                           maxWidth: .infinity,
                           minHeight: height(for: field),
                           maxHeight: height(for: field))
            case .Space:
                Spacer()
                    .frame(minWidth: .none,
                           maxWidth: self.width(field: field),
                           minHeight: field.line?.height(),
                           maxHeight: .infinity)
            case .Switch:
                SwitchView(field: field as? FBSwitchField)
                    .frame(minWidth: .none,
                           maxWidth: self.width(field: field),
                           minHeight: field.line?.height(),
                           maxHeight: .infinity)
            case .TextArea:
                TextAreaView(with: field as? FBTextAreaField)
                    .frame(minWidth: .none,
                           maxWidth: self.width(field: field),
                           minHeight: field.line?.height() ?? 30.0,
                           maxHeight: .infinity)
            case .Unknown:
                Text("unknown")
            default:
                Text("unknown?")
            }
        }
    }
    
    public init(with field:FBField) {
        self.field = field
    }
        
    func height(for field: FBField?) -> CGFloat {
        
        return CGFloat(field?.style(colorScheme: colorScheme)?.value(forKey: "height") as? CGFloat ?? 50.0)
    }
    
    func background(for field: FBField?) -> Color {

        return Color(hex: field?.style(colorScheme: colorScheme)?.value(forKey: "background-color") as? String ?? "ffffffFF")
    }
}

/*
#Preview {
    FieldView(with: nil)
}
*/
