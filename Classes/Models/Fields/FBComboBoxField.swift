//
//  ComboBoxField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import SwiftUI

class FBComboBoxField: FBInputField
{
    var view: any View.Type = ComboBoxView.self
    
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
    
    public override var styleSet:FBStyleSet? {
        get {
            return self.line?.styleSet
        }
    }
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#ComboBox"
        
        if let file = self.line?.section?.form?.file
        {
            var i:Int = lines.0
            
            while (i <= lines.1)
            {
                switch (file.lines[i].keyword)
                {
                case FBKeyWord.Value:
                    self.data = file.lines[i].value
                    i += 1
                    
                    break
                case FBKeyWord.OptionSet:
                    if (file.lines[i].value != "")
                    {
                        self.optionSet = self.line?.section?.form?.settings.optionSet[file.lines[i].value]
                        self.optionSet?.field = self
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
                            optionRange.1 = i - 1
                            self.optionSet = FBOptionSet(field: self, file: file, lines: optionRange)
                        }
                    }
                    i += 1
                    
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
    
    var labelHeight:CGFloat
    {
        get
        {
            return self.captionHeight()
        }
    }
    
}
