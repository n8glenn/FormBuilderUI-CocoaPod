//
//  UIForm.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/16/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation 
//import UIKit

public enum FBOrientation:Int
{
    case Horizontal = 0
    case Vertical = 1
    case ReverseHorizontal = 2
    case ReverseVertical = 3
    case PlaceHolder = 4
}

public protocol FormDelegate
{
    func formLoaded()
    func updated(form:FBForm, field:FBField, value:Any?)
    var width:CGFloat { get }
    var height:CGFloat { get }
}

public class FBForm: ObservableObject
{
    // UIForm -- this represents the entire form, it holds sections of fields, it has data
    //           and methods to be used by the user interface to facilitate displaying data,
    //           data entry, validation of data, etc.
    //var traits:UITraitCollection = UITraitCollection()
    //var darkMode:Bool = false
    var tag:String? = "#Form"
    var styleClass:String? = nil
    public var styleSet:FBStyleSet? = nil // = FBStyleSet()
    {
        didSet {
            self.refresh()
        }
    }
    
    
    var settings:FBSettings = FBSettings(file: "Settings")
    public var sections:[FBSection] = []
    private var _editMode: Bool = false
    var editMode: Bool {
        get { return _editMode }
        set {
            _editMode = newValue
        }
    }
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    var file:FBFile? = nil
    private var _editable:Bool?
    var editable:Bool
    {
        get
        {
            // this form is ONLY editable if none of its parents are explicitly set as NOT editable.
            if ((_editable == nil) || (_editable == true))
            {
                return true
            }
            return false
        }
        set(newValue)
        {
            _editable = newValue
        }
    }

    var visibleSections:[FBSection]
    {
        get 
        {
            var visible:[FBSection] = []
            for section in self.sections
            {
                if (section.visibleLines.count > 0)
                {
                    visible.append(section)
                }
            }
            return visible
        }
    }

    public var delegate:FormDelegate?
    
    public init(file: String, style: String?) {

        self.styleSet = FBStyleSet(named: "DefaultStyle")
        if let style = style {
            self.styleSet?.load(file: style)
        }
        self.styleClass = self.tag
        self.file = FBFile(file: file)
        
        guard let file = self.file else {
            return
        }
        var i:Int = 0
        while (i < file.lines.count)
        {
            switch (self.file!.lines[i].keyword)
            {
            case FBKeyWord.Style:
                //self.tag = self.file!.lines[i].value
                if let styleClass = self.file?.lines[i].value {
                    self.styleClass = styleClass
                }
                i += 1
                
                break
            case FBKeyWord.Editable:
                self.editable = (file.lines[i].value.lowercased() != "false")
                i += 1
                break
            case FBKeyWord.Section:
                let indentLevel:Int = file.lines[i].indentLevel
                let spaceLevel:Int = file.lines[i].spaceLevel
                i += 1
                var range = (i, i)
                while ((i < self.file!.lines.count) &&
                    ((file.lines[i].indentLevel > indentLevel) ||
                        (file.lines[i].spaceLevel > spaceLevel) ||
                    (file.lines[i].keyword == FBKeyWord.None)))
                {
                    i += 1
                }
                range.1 = i - 1
                self.sections.append(FBSection(form: self, lines: range))
                break
            default:
                i += 1
                break
            }
        }
    }
    
    public init(file:String, style:String, settings:String) {

        self.styleSet = FBStyleSet(named: "DefaultStyle")
        self.styleSet?.load(file: style)

        self.styleSet?.form = self
        self.settings.load(file: settings)
        self.styleClass = self.tag
        self.file = FBFile(file: file)
        
        guard let file = self.file else {
            return
        }
        var i:Int = 0
        while (i < file.lines.count)
        {
            switch (self.file!.lines[i].keyword)
            {
            case FBKeyWord.Style:
                if let _ = self.styleSet?.style(named: file.lines[i].value) {
                    self.styleClass = file.lines[i].value
                }
                i += 1
                
                break
            case FBKeyWord.Editable:
                self.editable = (file.lines[i].value.lowercased() != "false")
                i += 1
                break
            case FBKeyWord.Section:
                let indentLevel:Int = file.lines[i].indentLevel
                let spaceLevel:Int = file.lines[i].spaceLevel
                i += 1
                var range = (i, i)
                while ((i < self.file!.lines.count) &&
                    ((file.lines[i].indentLevel > indentLevel) ||
                        (file.lines[i].spaceLevel > spaceLevel) ||
                    (file.lines[i].keyword == FBKeyWord.None)))
                {
                    i += 1
                }
                range.1 = i - 1
                self.sections.append(FBSection(form: self, lines: range))
                break
            default:
                i += 1
                break
            }
        }
    }
    
    public init(file:String, style: String, delegate:FormDelegate)
    {
        self.styleSet = FBStyleSet(named: "DefaultStyle")
        self.styleSet?.load(file: style)
        self.delegate = delegate
        self.styleClass = self.tag
        
        self.file = FBFile(file: file)
        
        var i:Int = 0
        while (i < self.file!.lines.count)
        {
            switch (self.file!.lines[i].keyword)
            {
            case FBKeyWord.Style:
                if let _ = self.styleSet?.style(named: self.file?.lines[i].value ?? "") {
                    self.styleClass = self.file?.lines[i].value
                }
                i += 1
                
                break
            case FBKeyWord.Editable:
                self.editable = (self.file!.lines[i].value.lowercased() != "false")
                i += 1
                break
            case FBKeyWord.Section:
                let indentLevel:Int = self.file!.lines[i].indentLevel
                let spaceLevel:Int = self.file!.lines[i].spaceLevel
                i += 1
                var range = (i, i)
                while ((i < self.file!.lines.count) &&
                    ((self.file!.lines[i].indentLevel > indentLevel) ||
                        (self.file!.lines[i].spaceLevel > spaceLevel) ||
                    (self.file!.lines[i].keyword == FBKeyWord.None)))
                {
                    i += 1
                }
                range.1 = i - 1
                self.sections.append(FBSection(form: self, lines: range))
                break
            default:
                i += 1
                break
            }
        }
    }

    public init(file:FBFile, style: String, delegate:FormDelegate)
    {
        self.styleSet = FBStyleSet(named: "DefaultStyle")
        self.styleSet?.load(file: style)
        self.delegate = delegate
        self.styleClass = self.tag
        
        self.file = file
        
        var i:Int = 0
        while (i < self.file?.lines.count ?? 0)
        {
            switch (self.file?.lines[i].keyword ?? FBKeyWord.Unknown)
            {
            case FBKeyWord.Style:
                if let _ = self.styleSet?.style(named: self.file?.lines[i].value ?? "") {
                    self.styleClass = self.file?.lines[i].value
                }
                i += 1
                
                break
            case FBKeyWord.Editable:
                self.editable = (self.file?.lines[i].value.lowercased() != "false")
                i += 1
                break
            case FBKeyWord.Section:
                
                let indentLevel:Int = self.file?.lines[i].indentLevel ?? 0
                let spaceLevel:Int = self.file?.lines[i].spaceLevel ?? 0
                var range = (i, i)
                i += 1
                while ((i < self.file?.lines.count ?? 0) &&
                    ((self.file?.lines[i].indentLevel ?? 0 > indentLevel) ||
                        (self.file?.lines[i].spaceLevel ?? 0 > spaceLevel) ||
                        (self.file?.lines[i].keyword ?? FBKeyWord.Unknown == FBKeyWord.None)))
                {
                    i += 1
                    range.1 += 1
                }
                self.sections.append(FBSection(form: self, lines: range))
                break
            default:
                i += 1
                break
            }
        }
    }
    
    public func validate() -> Array<FBException>
    {
        // loop through all of the fields in the form and validate each one.
        // return all of the exceptions found during validation.
        var exceptions:Array<FBException> = Array<FBException>()
        for section in self.visibleSections
        {
            for line in section.visibleLines
            {
                for field in line.visibleFields
                {
                    let exception:FBException = field.validate()
                    if (exception.errors.count > 0)
                    {
                        exceptions.append(exception)
                    }
                }
            }
        }
        return exceptions
    }
    
    public func save()
    {
        for field in self.fields()
        {
            field.data = field.input
        }
    }
    
    public func setValue(for path: String, to data: Any?) {
        self.field(withPath: path)?.data = data
    }
    
    public func line(section:String, name:String) -> FBLine
    {
        return (self.section(named: section)?.line(named: name))!
    }
    
    public func section(named:String) -> FBSection?
    {
        for section in self.sections
        {
            if (section.id.lowercased() == named.lowercased())
            {
                return section
            }
        }
        return nil
    }
    
    public func line(withPath:String) -> FBLine?
    {
        var section:FBSection? = nil
        let path:Array<String> = withPath.components(separatedBy: ".")
        if (path.count > 0)
        {
            section = self.section(named: path[0])
        }
        if ((section != nil) && (path.count > 1))
        {
            return section?.line(named: path[1])
        }
        return nil
    }

    public func field(withPath:String) -> FBField?
    {
        var section:FBSection? = nil
        var line:FBLine? = nil
        let path:Array<String> = withPath.components(separatedBy: ".")
        if (path.count > 0)
        {
            section = self.section(named: path[0])
        }
        if ((section != nil) && (path.count > 1))
        {
            line = section?.line(named: path[1])
        }
        if (line != nil)
        {
            if (line?.fields.count == 1)
            {
                return line?.fields[0]
            }
            else
            {
                if (path.count > 2)
                {
                    return line?.field(named: path[2])
                }
            }
        }
        return nil
    }
        
    var style:FBStyleClass? {
        get {
            if let styleClass = self.styleClass  {
                if let styleClass = styleSet?.style(named: styleClass) {
                    return FBStyleClass(with:styleClass, styleSet: styleSet)
                }
            }
            return nil
        }
    }
    
    func fieldCount() -> Int
    {
        var count:Int = 0
        for section in self.visibleSections
        {
            count += section.lineCount()
        }
        return count
    }
    
    public func fields() -> [FBField]
    {
        var fields:[FBField] = []
        for section:FBSection in self.sections
        {
            for line:FBLine in section.lines
            {
                for field:FBField in line.fields
                {
                    fields.append(field)
                }
            }
        }
        return fields
    }
    
    public func refresh() {
        for section in sections {
            for line in section.visibleLines {
                for field in line.visibleFields {
                    field.needsRefresh = true
                }
                line.objectWillChange.send()
            }
            section.objectWillChange.send()
        }
        self.objectWillChange.send()
    }
}
