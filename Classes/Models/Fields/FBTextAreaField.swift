//
//  TextAreaField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import SwiftUI

class FBTextAreaField: FBInputField
{
    var view: any View.Type = TextAreaView.self
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#TextArea"
        if let file = self.line?.section?.form?.file
        {
            var i:Int = lines.0
            
            while (i <= lines.1)
            {
                switch (file.lines[i].keyword)
                {
                case FBKeyWord.Value:
                    self.data = file.lines[i].value
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
                                self.data = ((self.data ?? "") as! String) + value
                            }
                        }
                        else
                        {
                            break
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
    
    override func height() -> CGFloat
    {
        let height = self.captionHeight() + self.dataHeight() + ((self.topMargin() * 2)) + ((self.bottomMargin() * 2))
        if (height < self.style()?.value(forKey: "height") as? CGFloat ?? 30.0)
        {
            return self.style()?.value(forKey: "height") as? CGFloat ?? 30.0
        }
        else
        {
            return height
        }
    }
}
