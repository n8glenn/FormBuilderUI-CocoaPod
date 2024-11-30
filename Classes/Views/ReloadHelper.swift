//
//  ReloadHelper.swift
//
//
//  Created by Nathan Glenn on 5/11/24.
//

import Foundation

class ReloadViewHelper: ObservableObject {
    func reloadView() {
        objectWillChange.send()
    }
}
