//
//  DatePickerField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import SwiftUI

class FBDatePickerField: FBInputField
{
    var view: any View.Type = DatePickerView.self
    
    var dialog:FBDialog? = nil
    var dateType:FBDateType = FBDateType.Date

    var labelHeight:CGFloat
    {
        get
        {
            return self.captionHeight()
        }
    }

    var textHeight:CGFloat
        {
        get
        {
            return self.captionHeight() 
        }
    }

    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#DatePicker"
        var i:Int = lines.0
        if let file = self.line?.section?.form?.file
        {
            while (i <= lines.1)
            {
                switch (file.lines[i].keyword)
                {
                case FBKeyWord.Value:
                    self.data = file.lines[i].value
                    i += 1
                    
                    break
                case FBKeyWord.DateMode:
                    self.dateType = FBField.dateTypeWith(string: file.lines[i].value)
                    i += 1
                    
                    break
                case FBKeyWord.Style:
                    self.tag = file.lines[i].value
                    i += 1
                    
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
                case FBKeyWord.Dialog:
                    let indentLevel:Int = file.lines[i].indentLevel
                    let spaceLevel:Int = file.lines[i].spaceLevel
                    i += 1
                    var fieldRange = (i, i)
                    
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
                    fieldRange.1 = i - 1
                    self.dialog = FBDialog(type: FBDialogType.Date, field: self, lines: fieldRange)
                    
                    break
                default:
                    i += 1
                    
                    break
                }
            }
        }
    }
}
