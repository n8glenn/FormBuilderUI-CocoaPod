//
//  LabelField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit
import SwiftUI

class FBLabelField: FBField
{
    var view: any View.Type = LabelView.self
    
    override func height() -> CGFloat
    {
        let size = sizeOfString(string: self.caption ?? "", constrainedToWidth: self.width())
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
            return ((self.line?.section?.form?.width ?? 0.0) / CGFloat(self.line?.visibleFields.count ?? 1)) - sideMargins()
        }
    }
    
    private func sideMargins() -> CGFloat {
        return self.leftMargin() + self.rightMargin()
    }

    func textHeight() -> CGFloat
    {
        return self.captionHeight()  //self.line?.height() ?? 0
    }
    
    func labelHeight() -> CGFloat
    {
        return self.captionHeight()
    }

    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#Label"

        var i:Int = lines.0
        if let file = self.line?.section?.form?.file
        {
            while (i <= lines.1)
            {
                switch (file.lines[i].keyword)
                {
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
