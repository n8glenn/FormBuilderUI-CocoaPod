//
//  FBLine.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/17/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation 
import SwiftUI

public class FBLine: Identifiable, ObservableObject
{
    public var id:String = ""
    public var tag:String? = "#Line"
    public var styleSet:FBStyleSet? {
        get {
            return self.section?.styleSet
        }
    }

    func style() -> FBStyleClass?
    {
        return self.styleSet?.style(named: self.tag ?? "")
    }
    
    func style(colorScheme: ColorScheme) -> FBStyleClass?
    {
        return self.styleSet?.style(named: self.tag ?? "", darkMode: colorScheme == .dark)
    }

    public var visible:Bool = true
    var allowsRemove:Bool = false
    public var fields:[FBField] = []
    public var section:FBSection?
    
    func height() -> CGFloat
    {
        var height:CGFloat = 0.0
        for field in self.visibleFields
        {
            if field.height() > height {
                height = field.height()
            }
        }
        return height
    }

    func borderWidth() -> CGFloat
    {
        return self.style()?.value(forKey: "border") as? CGFloat ?? 0.0
    }

    public var width:CGFloat {
        get {
            return self.section?.width ?? 0.0
        }
    }
    var range = (0, 0)
    private var _editable:Bool?
    var editable:Bool?
    {
        get
        {
            // this line is ONLY editable if none of its parents are explicitly set as NOT editable.
            if (self.section?.form?.editable ?? true)
            {
                if (self.section?.editable ?? true)
                {
                    if ((_editable == nil) || (_editable == true))
                    {
                        return true
                    }
                }
            }
            return false
        }
        set(newValue)
        {
            _editable = newValue
        }
    }

    var visibleFields:[FBField]
    {
        get
        {
            var visible:[FBField] = []
            for field in fields
            {
                if (field.visible == true)
                {
                    visible.append(field)
                }
            }
            return visible
        }
    }
    
    var fieldCount:Int
    {
        get 
        {
            return self.visibleFields.count
        }
    }

    public init(section:FBSection, lines:(Int, Int))
    {
        
        self.section = section
        if let file = self.section?.form?.file
        {
        
            var i:Int = lines.0
            while (i <= lines.1)
            {
                switch (file.lines[i].keyword)
                {
                case FBKeyWord.Id:
                    self.id = file.lines[i].value
                    i += 1
                    
                    break
                case FBKeyWord.Visible:
                    self.visible = (file.lines[i].value.lowercased() != "false")
                    i += 1
                    
                    break
                case FBKeyWord.Style:
                    if let _ = self.styleSet?.style(named: file.lines[i].value) {
                        self.tag = file.lines[i].value
                    }
                    i += 1
                    
                    break
                case FBKeyWord.Editable:
                    self.editable = (file.lines[i].value.lowercased() != "false")
                    i += 1
                    
                    break
                case FBKeyWord.Field:
                    let indentLevel:Int = file.lines[i].indentLevel
                    let spaceLevel:Int = file.lines[i].spaceLevel
                    i += 1
                    var fieldRange = (i, i)
                    var fieldType:FBFieldType = FBFieldType.Unknown
                    while (i <= lines.1)
                    {
                        if ((file.lines[i].indentLevel > indentLevel) ||
                            (file.lines[i].spaceLevel > spaceLevel) ||
                            (file.lines[i].keyword == FBKeyWord.None))
                        {
                            if (file.lines[i].keyword == FBKeyWord.FieldType)
                            {
                                fieldType = FBField.typeWith(string: file.lines[i].value)
                            }
                            i += 1
                        }
                        else
                        {
                            break
                        }
                    }
                    fieldRange.1 = i - 1
                    
                    switch (fieldType)
                    {
                    case FBFieldType.Section:
                        break
                    case FBFieldType.Heading:
                        let field:FBHeadingField = FBHeadingField(line: self, lines: fieldRange)
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.Label:
                        let field:FBLabelField = FBLabelField(line: self, lines: fieldRange)
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.Text:
                        let field:FBTextField = FBTextField(line: self, lines: fieldRange)
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.TextArea:
                        let field:FBTextAreaField = FBTextAreaField(line: self, lines: fieldRange)
                        field.line = self
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.ComboBox:
                        let field:FBComboBoxField = FBComboBoxField(line: self, lines: fieldRange)
                        field.line = self
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.CheckBox:
                        let field:FBCheckBoxField = FBCheckBoxField(line: self, lines: fieldRange)
                        field.line = self
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.Image:
                        let field:FBImageField = FBImageField(line: self, lines: fieldRange)
                        field.line = self
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.ImagePicker:
                        let field:FBImagePickerField = FBImagePickerField(line: self, lines: fieldRange)
                        field.line = self
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.OptionSet:
                        let field:FBOptionSetField = FBOptionSetField(line: self, lines: fieldRange)
                        field.line = self
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.DatePicker:
                        let field:FBDatePickerField = FBDatePickerField(line: self, lines: fieldRange)
                        field.line = self
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.Signature:
                        let field:FBSignatureField = FBSignatureField(line: self, lines: fieldRange)
                        field.line = self
                        self.fields.append(field as FBField)
                        
                        break
                    case FBFieldType.Switch:
                        break
                    case FBFieldType.Space:
                        break
                    case FBFieldType.Unknown:
                        
                        break
                    }
                    
                    break
                default:
                    i += 1
                    break
                }
            }
        }
    }
    
    func initWith(section:FBSection, id:String) -> FBLine
    {
        self.section = section
        self.id = id  as String
        self.visible = true
        return self
    }
    
    func equals(value:String) -> Bool
    {
        return Bool(self.id.lowercased() == value.lowercased())
    }
    
    func field(named:String) -> FBField?
    {
        for field in self.fields
        {
            if (field.id.lowercased() == named.lowercased())
            {
                return field
            }
        }
        return nil
    }
    
    public func refresh() {
        var needsRefresh:Bool = false
        for field in self.fields {
            if field.needsRefresh {
                needsRefresh = true
            }
        }
        if needsRefresh {
            self.objectWillChange.send()
        }
    }
}
