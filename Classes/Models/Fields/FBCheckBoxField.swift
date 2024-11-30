//
//  CheckBoxField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class FBCheckBoxField: FBInputField
{
    var view: any View.Type = CheckBoxView.self
    
    public override func height() -> CGFloat
    {
        let size = sizeOfString(string: self.caption ?? "", constrainedToWidth: self.width() - (self.margin()) * 2)
        let height = size.height + ((self.style()?.value(forKey: "margin") as? CGFloat ?? 0) * 2)
        if (height < self.style()?.value(forKey: "height") as? CGFloat ?? 30.0)
        {
            return self.style()?.value(forKey: "height") as? CGFloat ?? 30.0
        }
        else
        {
            return height
        }
    }
    
    override func width() -> CGFloat
    {
        if self.line?.visibleFields.count ?? 0 == 0
        {
            return self.line?.section?.form?.width ?? 0
        } else {
            return (self.line?.section?.form?.width ?? 0 / CGFloat(self.line?.visibleFields.count ?? 0)) - (self.margin() * 2)
        }
    }
    
    var labelHeight:CGFloat
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
        
        self.tag = "#CheckBox"
        if let file = self.line?.section?.form?.file
        {
            var i:Int = lines.0
            
            while (i <= lines.1)
            {
                switch (file.lines[i].keyword)
                {
                case FBKeyWord.Value:
                    self.data = (file.lines[i].value.lowercased() == "true")
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
}
