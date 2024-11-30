//
//  FBSwitchField.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import Foundation
import SwiftUI

class FBSwitchField: FBInputField
{
    var view: any View.Type = SwitchView.self
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#Switch"
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
