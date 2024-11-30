//
//  ContentView.swift
//  FormBuilderExample
//
//  Created by Nathan Glenn on 9/28/23.
//

import SwiftUI
import FormBuilderUI

struct ContentView: View {
    @State private var contact:Contact = Contact(Street: "Street 1", City: "Bay City", State: "TX")
    var form:FBForm = FBForm(file: "Contact", style: "MyStyle", settings: "MySettings")
    @State private var errorString:String = ""
    @State private var showError:Bool = false
    @State private var styleChanged:Bool = false 
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            FormView(form: form, onLoad: { form in
                // when the form is loaded, we can initialize the form
                // with any existing data here...
                form.setValue(for: "address.street", to: contact.Street)
                form.setValue(for: "address.city", to: contact.City)
                form.setValue(for: "address.state", to: contact.State)
            },
                     onUpdate: { form, field, value in
                // when the fields are updated, we may want to update our form
                // based on the user input.  We can do that here...
                if field.id == "Country" && field.input as? String ?? "" ==  "CA" {
                    form.field(withPath: "address.province")?.visible = true
                    form.field(withPath: "address.state")?.visible = false
                } else {
                    form.field(withPath: "address.province")?.visible = false
                    form.field(withPath: "address.state")?.visible = true
                }
            },
                     onSave: { form in
                // when the form is validated successfully, we call save.
                // so we can update our objects here based on user input in the form.
                contact.Street = form.field(withPath: "address.street")?.input as? String ?? ""
                contact.City = form.field(withPath: "address.city")?.input as? String ?? ""
                contact.State = form.field(withPath: "address.state")?.input as? String ?? ""
            })
                .border(.gray)

            // this button shows how to update the form style...
            Button {
                toggleStyle()
            } label: {
                Text("Toggle Style")
            }
            
            // this button will call save, which validates the data in the form.
            // if the data is valid, then the "save" callback will be called.
            // otherwise, it will return an array of FBException objects, describing
            // the validation errors that occurred.
            Button {
                let errors:[FBException] = form.validate()
                if (errors.count == 0) {
                    form.save()
                } else {
                    errorString = ""
                    for exception:FBException in errors {
                        errorString += exception.message()
                    }
                    showError.toggle()
                }
            } label: {
                Text("Save")
            }
            .alert(errorString, isPresented: $showError) {
                // show any errors from form validation here...
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    // load style sets which alter the appearance of the form.
    func toggleStyle() {
        styleChanged.toggle()
        if styleChanged {
            self.form.styleSet = FBStyleSet(named: "GreenStyle")
        } else {
            self.form.styleSet = FBStyleSet(files: ["DefaultStyle", "MyStyle"])
        }
    }
}

#Preview {
    ContentView()
}
