//
//  FBOption.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 5/5/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation 

public class FBOption: NSObject, Identifiable
{
    public var id:String = ""
    var tag:String? = "#Option"
    public var styleSet:FBStyleSet? {
        get {
            return self.field?.styleSet
        }
    }
    var style:FBStyleClass? {
        get {
            if let styleClass = self.tag  {
                if let styleClass = styleSet?.style(named: styleClass) {
                    return FBStyleClass(with: styleClass, styleSet: styleSet)
                }
            }
            return nil
        }
    }
    var visible:Bool = true
    public var value:String = ""
    var field:FBField? = nil
    var range = (0, 0)
    
    override public init()
    {
        super.init()
    }

    public init(field:FBField?, file:FBFile, lines:(Int, Int))
    {
        super.init()
        
        self.field = field
        self.range = lines
        
        var i:Int = lines.0
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Id:
                self.id = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.Value:
                self.value = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.Visible:
                self.visible = (file.lines[i].description.lowercased() != "false")
                i += 1
                
                break
            case FBKeyWord.Style:
                self.tag = file.lines[i].description
                /*
                if let styleClass = self.styleSet?.style(named: self.tag ?? "") {
                    self.style = FBStyleClass(withClass:styleClass)
                }
                */
                /*
                if (self.field != nil)
                {
                    //self.style?.parent = self.field?.style // override the default parents, our styles always descend from the style of the parent object!
                }
                */
                i += 1
                
                break
            default:
                i += 1
                
                break
            }
        }
    }
}
