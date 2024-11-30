//
//  FBCSSProperty.swift
//  
//
//  Created by Nathan Glenn on 8/7/24.
//

import Foundation

public class FBCSSProperty {
    var name:String
    var value:String?
    
    init(name: String, value: String? = nil) {
        self.name = name
        self.value = value
    }
    
    init(line: String) {
        let tokens = line.components(separatedBy: [":", ";"])
        name = tokens.first ?? ""
        value = tokens.last ?? ""
    }
}
