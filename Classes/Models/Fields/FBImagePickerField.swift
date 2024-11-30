//
//  ImagePickerField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import SwiftUI

public enum FBImagePickerMode:Int
{
    case Album = 0
    case Camera = 1
}

class FBImagePickerField: FBInputField
{
    
    var view: any View.Type = ImagePickerView.self
    
    var imagePickerMode:FBImagePickerMode = FBImagePickerMode.Album

    static func imagePickerModeWith(string:String) -> FBImagePickerMode
    {
        switch (string.lowercased())
        {
        case "album":
            return FBImagePickerMode.Album
            
        case "camera":
            return FBImagePickerMode.Camera
            
        default:
            return FBImagePickerMode.Album
        }
    }

    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#ImagePicker"

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
                case FBKeyWord.PickerMode:
                    self.imagePickerMode = FBImagePickerField.imagePickerModeWith(string: file.lines[i].value)
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
