//
//  FormView.swift
//  
//
//  Created by Nathan Glenn on 9/28/23.
//

import SwiftUI

public struct FormView: View, FormDelegate {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName
    
    @State var size: CGSize = CGSize()
    @ObservedObject var form:FBForm
    private var edit:Bool = false
    public var width: CGFloat
    {
        get
        {
            return form.width //?? 0.0
        }
    }
    public var height: CGFloat
    {
        get
        {
            return form.height //?? 0.0
        }
    }
    private var loadAction: ((_ form: FBForm) -> Void)? = nil
    private var updateAction: ((_ form: FBForm, 
                                _ field: FBField,
                                _ value: Any?) -> Void)? = nil
    private var saveAction: ((_ form: FBForm) -> Void)? = nil
    
    public func formLoaded() {
        if let action = loadAction {
            action(self.form)
        }
    }
    
    public func updated(form: FBForm, field: FBField, value: Any?) {
        if let action = updateAction {
            action(form, field, value)
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            List {
                ForEach (form.visibleSections) { section in
                    SectionView(with: section)
                        .border(colorScheme == .dark ? .white : .black, width: section.borderWidth)
                }
            }
            .environment(\.styleName, form.styleSet?.name ?? "DefaultStyle")
            .listStyle(.plain)
            .onAppear {
                form.width = proxy.size.width
                form.height = proxy.size.height
                size = proxy.size
            }
            .onRotate { newOrientation in
                //orientation = newOrientationt
                /*
                switch newOrientation {
                case UIDeviceOrientation.portraitUpsideDown:
                    form.width = proxy.size.width
                    form.height = proxy.size.height

                case UIDeviceOrientation.portrait:
                    form.width = proxy.size.width
                    form.height = proxy.size.height

                case  UIDeviceOrientation.landscapeLeft:
                    form.width = proxy.size.height
                    form.height = proxy.size.width

                case UIDeviceOrientation.landscapeRight:
                    form.width = proxy.size.height
                    form.height = proxy.size.width
                default:
                    form.width = proxy.size.width
                    form.height = proxy.size.height
                }
                */
                let width = form.width
                let height = form.height
                form.width = height
                form.height = width
                form.refresh()

                print("form width = \(form.width)")
                print("form height = \(form.height)")
            }
        }
    }
    
    public init(form: FBForm) {
        self.form = form
        self.form.delegate = self
        formLoaded()
    }
    
    public init(named file: String) {
        form = FBForm(file: file, style: "Style")
        form.delegate = self
        formLoaded()
    }
    
    public init(named file: String, style: String) {
        form = FBForm(file: file, style: style)
        form.delegate = self
        formLoaded()
    }
    
    public init(named file: String,
                onLoad loadMethod: @escaping (_ form: FBForm) -> Void) {
        loadAction = loadMethod
        form = FBForm(file: file, style: "Style")
        form.delegate = self
        formLoaded()
    }
    
    public init(named file: String,
                style: String,
                onLoad loadMethod: @escaping (_ form: FBForm) -> Void) {
        loadAction = loadMethod
        form = FBForm(file: file, style: style)
        form.delegate = self
        formLoaded()
    }
    
    public init(named file: String,
                onLoad loadMethod: @escaping (_ form: FBForm) -> Void,
                onUpdate updateMethod: @escaping (_ form: FBForm, _ field: FBField, _ value: Any?) -> Void) {
        loadAction = loadMethod
        updateAction = updateMethod
        form = FBForm(file: file, style: "Style")
        form.delegate = self
        formLoaded()
    }
    
    public init(named file: String,
                style: String,
                onLoad loadMethod: @escaping (_ form: FBForm) -> Void,
                onUpdate updateMethod: @escaping (_ form: FBForm, _ field: FBField, _ value: Any?) -> Void) {
        loadAction = loadMethod
        updateAction = updateMethod
        form = FBForm(file: file, style: style)
        form.delegate = self
        formLoaded()
    }
    
    public init(named file: String,
                onLoad loadMethod: @escaping (_ form: FBForm) -> Void,
                onUpdate updateMethod: @escaping (_ form: FBForm, _ field: FBField, _ value: Any?) -> Void,
                onSave saveMethod: @escaping (_ form: FBForm) -> Void) {
        loadAction = loadMethod
        updateAction = updateMethod
        saveAction = saveMethod
        form = FBForm(file: file, style: "Style")
        form.delegate = self
        formLoaded()
    }
    
    public init(named file: String,
                style: String,
                onLoad loadMethod: @escaping (_ form: FBForm) -> Void,
                onUpdate updateMethod: @escaping (_ form: FBForm, _ field: FBField, _ value: Any?) -> Void,
                onSave saveMethod: @escaping (_ form: FBForm) -> Void) {
        loadAction = loadMethod
        updateAction = updateMethod
        saveAction = saveMethod
        form = FBForm(file: file, style: style)
        form.delegate = self
        formLoaded()
    }
    
    public init(form: FBForm,
                onLoad loadMethod: @escaping (_ form: FBForm) -> Void,
                onUpdate updateMethod: @escaping (_ form: FBForm, _ field: FBField, _ value: Any?) -> Void,
                onSave saveMethod: @escaping (_ form: FBForm) -> Void) {
        loadAction = loadMethod
        updateAction = updateMethod
        saveAction = saveMethod
        self.form = form
        self.form.delegate = self
        formLoaded()
    }
}

#Preview {
    FormView(named: "Contact")
        .border(.black, width: 0.5)
}

