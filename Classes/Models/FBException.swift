//
//  FBException.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/19/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation

public class FBException: NSObject
{
    public var field:FBField?
    public var errors:[FBRequirementType] = []
    
    public func message() -> String {
        
        var output:String = ""
        for type in self.errors
        {
            switch (type)
            {
            case FBRequirementType.Required:
                output = output + (self.field?.caption)! + " is required.\n"
                break
            case FBRequirementType.Maximum:
                output = output + (self.field?.caption)! + " exceeds the maximum.\n"
                break
            case FBRequirementType.Minimum:
                output = output + (self.field?.caption)! + " does not meet the minimum.\n"
                break
            case FBRequirementType.Format:
                output = output + (self.field?.caption)! + " is not valid.\n"
                break
            case FBRequirementType.MemberOf:
                output = output + (self.field?.caption)! + " is not one of the available options.\n"
                break
            default:
                break
            }
        }
        return output
    }
}
