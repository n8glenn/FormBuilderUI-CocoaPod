//
//  FBDialog.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 5/28/18.
//

import Foundation

public enum FBDialogType:Int
{
    case Date = 0
    case Signature = 1
}

open class FBDialog: NSObject
{
    var field:FBInputField? = nil
    var tag:String? = "#Dialog"
    var type:FBDialogType? = nil
    public var styleSet:FBStyleSet? {
        get {
            return self.field?.styleSet
        }
    }

    override public init()
    {
        super.init()
    }
    
    public init(type:FBDialogType, field:FBInputField, lines:(Int, Int))
    {
        super.init()
        
        self.type = type
        self.field = field 
        switch (self.type!)
        {
        case FBDialogType.Date:
            self.tag = "#DateDialog"
            break
        case FBDialogType.Signature:
            self.tag = "#SignatureDialog"
            break
        }
        var i:Int = lines.0
        let file = self.field!.line!.section!.form!.file!
        
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
    
    var style:FBStyleClass?
    {
        get
        {
            return self.styleSet?.style(named: self.tag ?? "", darkMode: false)
        }
    }
}
