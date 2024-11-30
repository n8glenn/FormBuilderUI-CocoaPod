//
//  Field.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/16/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import SwiftUI

public enum FBFieldType:Int
{
    case Unknown = 0
    case Section = 1
    case Heading = 2
    case Label = 3
    case Image = 4
    case ImagePicker = 5
    case Text = 6
    case TextArea = 7
    case ComboBox = 8
    case CheckBox = 9
    case OptionSet = 10
    case Signature = 11
    case DatePicker = 12
    case Switch = 13
    case Space = 14
}

public enum FBDateType:Int
{
    case Date = 0
    case Time = 1
    //case DateTime = 2
}

open class FBField: NSObject, Identifiable, ObservableObject
{
    // Field -- represents a line of data in the form (although potentially more than one field can
    //          be put on one line, this won't usually be the case)  the field is an item of data to
    //          be entered into the form, it can be validated and it can also potentially be
    //          replicated if allowed by the section it's in.
    
    public var id:String = ""
    public var hasInput:Bool = false
    public var hasData:Bool = false
    public var needsRefresh:Bool = false
    var tag:String? = "#Field"
    var _visible:Bool = true
    public var styleSet:FBStyleSet? {
        get {
            return self.line?.styleSet
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

    public var line:FBLine?
    public var fieldType:FBFieldType = FBFieldType.Heading
    public var caption:String? = ""
    public func height() -> CGFloat {
        return style()?.value(forKey: "height") as? CGFloat ?? 50.0
    }
    public func width() -> CGFloat
    {
        if self.line?.visibleFields.count ?? 0 == 0
        {
            return (self.line?.section?.form?.width ?? 0) - sideMargins() - (self.required ? 25.0 : 0.0)
        } else {
            return ((self.line?.section?.form?.width ?? 0.0) / CGFloat(self.line?.visibleFields.count ?? 1)) - sideMargins() - (self.required ? 25.0 : 0.0)
        }
    }
    private func sideMargins() -> CGFloat {
        return self.leftMargin() + self.rightMargin()
    }
    public func captionHeight() -> CGFloat {
        
        return sizeOfString(string: self.caption ?? "", constrainedToWidth: self.width()).height
    }
    public func dataHeight() -> CGFloat {
        
        return self.style()?.value(forKey: "text-height") as? CGFloat ?? 300.0
        //return sizeOfString(string: self.data as? String ?? "", constrainedToWidth: self.width()).height
    }
    public func height(of text:String, with font: Font, and width: CGFloat) -> CGFloat {
        
        return 0.0
    }
    public func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: self.style()?.font ?? UIFont.systemFont(ofSize: 17)],
            context: nil).size
    }
    public var visible:Bool {
        get  {
            return _visible
        }
        set {
            _visible = newValue
            self.line?.section?.form?.refresh()
        }
    }
    var range = (0, 0)
    private var _labelHeight:CGFloat = 30.0
    private var _textHeight:CGFloat = 30.0
    var requiredWidth:CGFloat = 5.0
    var requiredHeight:CGFloat = 5.0
    // the style properties control how the field is displayed, the display properties may be set in any parent class
    // all the way up to the form, and it may be overridden at every level as well.  So first we check to see if the value
    // has been set for this field, if not, has it been set for the line, if not, has it been set for the section, if not
    // has it been set for the form, and if not, is it set in the settings singleton?
    
    public var required:Bool
    {
        get
        {
            return false
        }
        set(newValue)
        {
            // do nothing
        }
    }

    public var input:Any?
    {
        get
        {
            return nil
        }
        set(newValue)
        {
            // do nothing
        }
    }

    public var data:Any?
    {
        get
        {
            return nil
        }
        set(newValue)
        {
            // do nothing 
        }
    }
    
    var optionSet:FBOptionSet?
    {
        get
        {
            return nil
        }
        set(newValue)
        {
            // do nothing
        }
    }

    var editMode:Bool
    {
        get
        {
            return false
        }
    }
    var editing:Bool
    {
        get
        {
            return false
        }
    }
    
    override public init()
    {
        super.init()
    }

    public init(line:FBLine, lines:(Int, Int))
    {
        super.init()
        
        self.line = line
        self.range = lines
        if let file = self.line?.section?.form?.file
        {
            var i:Int = lines.0
            while (i <= lines.1)
            {
                switch (file.lines[i].keyword)
                {
                case FBKeyWord.None:
                    i += 1
                    
                    break
                case FBKeyWord.Unknown:
                    i += 1
                    
                    break
                case FBKeyWord.Id:
                    self.id = file.lines[i].value
                    i += 1
                    
                    break
                case FBKeyWord.Visible:
                    self.visible = (file.lines[i].value.lowercased() != "false")
                    i += 1
                    
                    break
                case FBKeyWord.Style:
                    self.tag = file.lines[i].value
                    i += 1
                    
                    break
                case FBKeyWord.Dialog:
                    let indentLevel:Int = file.lines[i].indentLevel
                    let spaceLevel:Int = file.lines[i].spaceLevel
                    i += 1
                    while (i <= lines.1)
                    {
                        if ((file.lines[i].indentLevel > indentLevel) ||
                            (file.lines[i].spaceLevel > spaceLevel) ||
                            (file.lines[i].keyword == FBKeyWord.None))
                        {
                            i += 1
                        }
                        else
                        {
                            break
                        }
                    }
                    
                    break
                case FBKeyWord.Requirements:
                    let indentLevel:Int = file.lines[i].indentLevel
                    let spaceLevel:Int = file.lines[i].spaceLevel
                    i += 1
                    while (i <= lines.1)
                    {
                        if ((file.lines[i].indentLevel > indentLevel) ||
                            (file.lines[i].spaceLevel > spaceLevel) ||
                            (file.lines[i].keyword == FBKeyWord.None))
                        {
                            i += 1
                        }
                        else
                        {
                            break
                        }
                    }

                    break
                case FBKeyWord.FieldType:
                    self.fieldType = FBField.typeWith(string: file.lines[i].value)
                    i += 1
                    
                    break
                case FBKeyWord.Caption:
                    self.caption = file.lines[i].value
                    while (i < lines.1)
                    {
                        if (file.lines[i].continued)
                        {
                            i += 1
                            if (i <= lines.1)
                            {
                                var value:String = file.lines[i].value
                                value = value.replacingOccurrences(of: "\\n", with: "\n", options: [], range: nil)
                                value = value.replacingOccurrences(of: "\\t", with: "\t", options: [], range: nil)
                                value = value.replacingOccurrences(of: "\\r", with: "\r", options: [], range: nil)
                                value = value.replacingOccurrences(of: "\\\"", with: "\"", options: [], range: nil)
                                self.caption = (self.caption ?? "") + value
                            }
                        }
                        else
                        {
                            break
                        }
                    }
                    i += 1
                    
                    break
                default:
                    i += 1
                    break
                }
            }
        }
    }
    
    func initWith(line:FBLine, id:String, label:String, type:FBFieldType) -> FBField
    {
        self.line = line
        self.id = id as String
        self.fieldType = type
        self.caption = label
        self.visible = true

        return self
    }
    
    func validate() -> FBException
    {
        let exception:FBException = FBException()
        exception.field = self
        return exception
    }
    
    public func clear()
    {
        // do nothing here
        NSLog("in field clear")
    }
    
    func equals(value:String) -> Bool
    {
        return Bool(self.id.lowercased() == value.lowercased())
    }
        
    static func typeWith(string:String) -> FBFieldType
    {
        switch (string.lowercased())
        {
        case "section":
            return FBFieldType.Section
            
        case "heading":
            return FBFieldType.Heading

        case "label":
            return FBFieldType.Label

        case "image":
            return FBFieldType.Image
            
        case "imagepicker":
            return FBFieldType.ImagePicker

        case "text":
            return FBFieldType.Text

        case "textarea":
            return FBFieldType.TextArea

        case "combobox":
            return FBFieldType.ComboBox

        case "checkbox":
            return FBFieldType.CheckBox

        case "optionset":
            return FBFieldType.OptionSet

        case "signature":
            return FBFieldType.Signature
        
        case "datepicker":
            return FBFieldType.DatePicker
            
        default:
            return FBFieldType.Heading
        }
    }

    static func dateTypeWith(string:String) -> FBDateType
    {
        switch (string.lowercased())
        {
        case "date":
            return FBDateType.Date
            
        case "time":
            return FBDateType.Time

        default:
            return FBDateType.Date
        }
    }
    
    func isNil(someObject: Any?) -> Bool {
        if someObject is String {
            if (someObject as? String) != nil && !((someObject as? String)?.isEmpty)! {
                return false
            }
        }
        if someObject is Array<Any> {
            if (someObject as? Array<Any>) != nil {
                return false
            }
        }
        if someObject is Dictionary<AnyHashable, Any> {
            if (someObject as? Dictionary<String, Any>) != nil {
                return false
            }
        }
        if someObject is Data {
            if (someObject as? Data) != nil {
                return false
            }
        }
        if someObject is Date {
            if (someObject as? Date != nil) {
                return false 
            }
        }
        if someObject is NSNumber {
            if (someObject as? NSNumber) != nil{
                return false
            }
        }
        if someObject is UIImage {
            if #available(iOS 13.0, *) {
                if (someObject as? UIImage) != nil {
                    return false
                }
            } else {
                // Fallback on earlier versions
                return false
            }
        }
        return true
    }
    
    func margin() -> CGFloat {
        return CGFloat(floatLiteral: CGFloat.NativeType(self.style()?.value(forKey: "margin") as? CGFloat ?? 0.0))
    }
    
    func topMargin() -> CGFloat {
        let topMargin = self.style()?.value(forKey: "top-margin") as? CGFloat ?? 0.0
        if (topMargin == 0.0) {
            return margin()
        } else {
            return topMargin
        }
    }

    func bottomMargin() -> CGFloat {
        let bottomMargin = self.style()?.value(forKey: "bottom-margin") as? CGFloat ?? 0.0
        if (bottomMargin == 0.0) {
            return margin()
        } else {
            return bottomMargin
        }
    }

    func leftMargin() -> CGFloat {
        let leftMargin = self.style()?.value(forKey: "left-margin") as? CGFloat ?? 0.0
        if (leftMargin == 0.0) {
            return margin()
        } else {
            return leftMargin
        }
    }

    func rightMargin() -> CGFloat {
        let rightMargin = self.style()?.value(forKey: "right-margin") as? CGFloat ?? 0.0
        if (rightMargin == 0.0) {
            return margin()
        } else {
            return rightMargin
        }
    }

    func refresh() {
        self.objectWillChange.send()
    }
}
