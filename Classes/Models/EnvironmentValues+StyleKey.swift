//
//  EnvironmentValues.swift
//
//
//  Created by Nathan Glenn on 9/2/24.
//

import SwiftUI

private struct StyleKey: EnvironmentKey {
    
    static let defaultValue: String = "DefaultStyle"
}

extension EnvironmentValues {
    var styleName: String {
        get { self[StyleKey.self] }
        set { self[StyleKey.self] = newValue }
    }

}
