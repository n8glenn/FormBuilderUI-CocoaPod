//
//  SwiftUIView.swift
//  
//
//  Created by Nathan Glenn on 8/4/24.
//

import SwiftUI

// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            //.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.UIDeviceOrientationDidChange)) { _ in
            //    action(UIDevice.current.orientation)
            //}
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
