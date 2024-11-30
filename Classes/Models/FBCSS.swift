//
//  FBCSS.swift
//  
//
//  Created by Nathan Glenn on 8/7/24.
//

import Foundation


public class FBCSS : NSObject {
    
    public var classes:[FBCSSClass] = []
    
    public override init()
    {
        super.init()

    }
    
    public init(file:String)
    {
        super.init()
        self.load(file: file)
    }
    
    public func load(file: String)
    {
        var path:String? = nil
        
        path = Bundle.main.path(forResource: file, ofType: "css")
        if (path == nil)
        {
            path = Bundle.main.path(forResource: file, ofType: "css")
        }
        if (path == nil)
        {
            let bundle = Bundle.init(for: self.classForCoder)
            path = bundle.path(forResource: file, ofType: "css")
        }
        if (path == nil)
        {
            return
        }
        
        do {
            let content:String = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            var tokens = content.components(separatedBy: .newlines)
            var currentTokens:[String] = []

            while (tokens.count > 0)
            {
                let currentToken = tokens.removeFirst()
                switch currentToken.trimmingCharacters(in: .whitespaces) {
                case "{":
                    break
                case "":
                    break
                case "}":
                    classes.append(FBCSSClass(lines: currentTokens))
                    currentTokens = []
                default:
                    currentTokens.append(currentToken)
                }
            }
        } catch _ as NSError {
            return
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
