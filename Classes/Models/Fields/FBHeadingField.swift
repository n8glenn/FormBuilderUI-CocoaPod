//
//  HeadingField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import SwiftUI

class FBHeadingField: FBField
{
    var view: any View.Type = HeadingView.self
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#Heading"

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
