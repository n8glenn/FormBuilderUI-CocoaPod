//
//  ImageField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import SwiftUI

class FBImageField: FBField
{
    var view: any View.Type = ImageView.self
    
    private var _data:Any? = nil
    override var data:Any?
        {
        get
        {
            return _data
        }
        set(newValue)
        {
            _data = newValue
        }
    }

    var labelHeight:CGFloat
    {
        get
        {
            if (self.caption?.isEmpty ?? true)
            {
                return 0.0
            }
            else
            {
                return self.captionHeight()
            }
        }
    }

    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#Image"

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
