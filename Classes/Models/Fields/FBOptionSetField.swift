//
//  OptionSetField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import SwiftUI

class FBOptionSetField: FBInputField
{
    var view: any View.Type = OptionSetView.self
    
    private var _optionSet:FBOptionSet?
    override var optionSet:FBOptionSet?
        {
        get
        {
            return _optionSet
        }
        set(newValue)
        {
            _optionSet = newValue
        }
    }
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#OptionSet"

        if let file = self.line?.section?.form?.file
        {
            var optionSetId:String? = nil
            var i:Int = lines.0
            
            while (i <= lines.1)
            {
                switch (file.lines[i].keyword)
                {
                case FBKeyWord.Value:
                    self.data = file.lines[i].value.description
                    i += 1
                    
                    break
                case FBKeyWord.Id:
                    optionSetId = file.lines[i].value
                    i += 1
                    
                    break
                case FBKeyWord.OptionSet:
                    if (file.lines[i].value != "")
                    {
                        self.optionSet = self.line?.section?.form?.settings.optionSet[file.lines[i].value]
                        self.optionSet?.field = self
                        i += 1
                    }
                    else
                    {
                        let indentLevel:Int = file.lines[i].indentLevel
                        let spaceLevel:Int = file.lines[i].spaceLevel
                        i += 1
                        var optionRange = (i, i)
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
                        optionRange.1 = i - 1
                        if (optionSetId != nil)
                        {
                            self.line?.section?.form?.settings.optionSet[optionSetId!] = FBOptionSet(field: self, file: file, lines: optionRange)
                            self.optionSet = self.line?.section?.form?.settings.optionSet[optionSetId!]
                        }
                        else
                        {
                            self.optionSet = FBOptionSet(field: self, file: file, lines: optionRange)
                        }
                        self.optionSet?.field = self
                    }
                    
                    break
                case FBKeyWord.Style:
                    self.tag = file.lines[i].value
                    i += 1
                    
                    break
                default:
                    i += 1
                    
                    break
                }
            }
        }
    }
}
