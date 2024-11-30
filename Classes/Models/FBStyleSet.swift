//
//  FBStyleSet.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/5/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation 
import SwiftUI

open class FBStyleSet: NSObject
{
    var name: String?
    var classes:[FBStyleClass] = []
    public var darkMode:Bool = false
    public var form:FBForm? = nil 
    
    func style(named: String) -> FBStyleClass?
    {
        //print("style = \(named)")
        for style in self.classes
        {
            if (style.name?.lowercased() == named.lowercased())
            {
                return style
            }
        }
        return nil
    }

    func style(named: String, darkMode: Bool) -> FBStyleClass?
    {
        var styleName = named
        if darkMode {
            styleName += "Dark"
        } else {
            styleName += "Light"
        }
        //print("style = \(styleName)")
        for style in self.classes
        {
            if (style.name?.lowercased() == styleName.lowercased())
            {
                return style
            }
        }
        // if no dark or light found, use default
        for style in self.classes {
            if (style.name?.lowercased() == named.lowercased())
            {
                return style
            }
        }

        return nil
    }
    
    public init(named style: String)
    {
        super.init()
        self.name = style
        self.load(file: style)
    }
    
    public init(files: [String]) {
        super.init()
        self.name = files.first ?? ""
        self.load(files: files)
    }
    
    open func load(files:[String]) {
    
        for file in files {
            load(file: file)
        }
    }
    
    open func load(file: String)
    {
        var path:URL? = nil
        path = Bundle.main.url(forResource: file, withExtension: "css")
        if (path == nil)
        {
            let bundle = Bundle.init(for: self.classForCoder)
            path = bundle.url(forResource: file, withExtension: "css")
        }
        if (path == nil)
        {
            return
        }
        
        let css = SwiftCSS(CssFileURL: path!)
        for item in css.parsedCss
        {
            //print(item)
            if (self.style(named: item.key) == nil)
            {
                let style:FBStyleClass = FBStyleClass()
                style.name = item.key
                style.properties = item.value as NSDictionary
                self.classes.append(style)
            }
            else
            {
                let style:FBStyleClass = self.style(named: item.key)!
                let properties:NSMutableDictionary = NSMutableDictionary(dictionary: style.properties!)
                for v in item.value
                {
                    properties.setValue(v.value, forKey: v.key)
                }
                style.properties = NSDictionary(dictionary: properties)
            }
        }
        
        // go back and set the parents...
        for style in self.classes
        {
            if (style.properties?.value(forKey: "parent") != nil)
            {
                style.parent = self.style(named: style.properties!.value(forKey: "parent") as? String ?? "")
            }
        }        
    }

    open func load(path: String)
    {
        let url:URL = URL(fileURLWithPath: path)
        let css = SwiftCSS(CssFileURL: url)
        for item in css.parsedCss
        {
            //print(item)
            if (self.style(named: item.key) == nil)
            {
                let style:FBStyleClass = FBStyleClass()
                style.name = item.key
                style.properties = item.value as NSDictionary
                self.classes.append(style)
            }
            else
            {
                let style:FBStyleClass = self.style(named: item.key)!
                let properties:NSMutableDictionary = NSMutableDictionary(dictionary: style.properties!)
                for v in item.value
                {
                    properties.setValue(v.value, forKey: v.key)
                }
                style.properties = NSDictionary(dictionary: properties)
            }
        }
        
        // go back and set the parents...
        for style in self.classes
        {
            if (style.properties!.value(forKey: "parent") != nil)
            {
                style.parent = self.style(named: style.properties!.value(forKey: "parent") as! String)
            }
        }
    }
}
