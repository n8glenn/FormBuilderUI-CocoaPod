//
//  File.swift
//  
//
//  Created by Nathan Glenn on 6/15/24.
//

import Foundation
import SwiftUI

extension View {

    func borderWidth(field: FBField?) -> CGFloat
    {
        var borderWidth:CGFloat = 0.0
        if ((field == field?.line?.fields.first) && (field == field?.line?.fields.last))
        {
            borderWidth = (field?.style()?.value(forKey: "border") as? CGFloat ?? 0.0) * 2.0
        }
        else if ((field == field?.line?.fields.first) || (field == field?.line?.fields.last))
        {
            borderWidth = (field?.style()?.value(forKey: "border") as? CGFloat ?? 0.0) * 1.5
        }
        else
        {
            borderWidth = (field?.style()?.value(forKey: "border") as? CGFloat ?? 0.0)
        }
        return borderWidth
    }
    
    func borderHeight(field: FBField?) -> CGFloat
    {
        return (field?.style()?.value(forKey: "border") as? CGFloat ?? 0.0)
    }
    
    func width(field: FBField?) -> CGFloat
    {
        return (field?.line?.width ?? 0 / CGFloat(field?.line?.fields.count ?? 1)) - self.borderWidth(field: field)
    }
}
