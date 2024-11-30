//
//  FBCSSClass.swift
//  
//
//  Created by Nathan Glenn on 8/7/24.
//

import Foundation

public class FBCSSClass: NSObject {
    
    public var name:String? = nil
    public var properties:[FBCSSProperty] = []
    
    public override init()
    {
        super.init()

    }
    
    public init(lines:[String])
    {
        super.init()
        self.load(lines: lines)
    }
    
    public func load(lines: [String])
    {
        do {

            var lineArray = lines
            self.name = lineArray.removeFirst()
            
            while (lines.count > 0)
            {
                let currentLine:String = lineArray.removeFirst()
                switch currentLine.trimmingCharacters(in: .whitespaces) {
                case "{":
                    break
                case "":
                    break
                case "}":
                    break
                default:
                    self.properties.append(FBCSSProperty(line: currentLine))
                }

            }
        //} catch _ as NSError {
        //    return
        }
    }

    /*
    public init(path: String)
    {
        super.init()
        do {
            let content:String = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var textlines = content.split(separator: "\n")
            var continued:Bool = false
            while (textlines.count > 0)
            {
                let line:FBFileLine = FBFileLine.init(line: (textlines.first?.description)!, continued: continued)
                continued = line.continued
                lines.append(line)
                textlines.removeFirst()
            }
        } catch _ as NSError {
            return
        }
    }
    */
}
