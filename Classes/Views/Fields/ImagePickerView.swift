//
//  ImagePickerView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    var field:FBImagePickerField? = nil
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var image: Image?
    @State private var photoPickerPresented:Bool = false
    @State var viewModel = PickerViewModel()

    var labelHeight:CGFloat
    {
        get
        {
            return 50.0 //self.caption!.height(withConstrainedWidth:
                //self.labelWidth,
                //                        font: self.style!.font)
        }
    }
    
    var labelWidth: CGFloat
    {
        get
        {
            return (self.width(field: field) / 2.0) - (margins() + self.borderWidth(field: field))
        }
    }
    
    func margins() -> CGFloat {
        return (field?.leftMargin() ?? 0.0)
        + (field?.rightMargin() ?? 0.0)
    }
    
    var body: some View {

        VStack {
            Text(self.field?.caption ?? "")
                .font(font())
                .padding(EdgeInsets(top: topMargin(),
                                    leading: leftMargin(),
                                    bottom: bottomMargin(),
                                    trailing: rightMargin()))

            image?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            HStack {
                Image(systemName: "camera.circle.fill")
                    .onTapGesture {
                        photoPickerPresented.toggle()
                    }
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
                    .photosPicker(isPresented: $photoPickerPresented, selection: $photoPickerItem)
                    .onChange(of: photoPickerItem) {
                        Task {
                            if let loaded = try? await photoPickerItem?.loadTransferable(type: Image.self) {
                                image = loaded
                                field?.input = image
                                field?.hasInput = true
                            } else {
                                //print("Failed")
                            }
                        }
                    }
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.red)
                    .shadow(radius: 2.5)
                    .opacity(self.field?.required ?? false ? 1.0 : 0.0)
                    .padding(EdgeInsets(top: topMargin(),
                                        leading: leftMargin(),
                                        bottom: bottomMargin(),
                                        trailing: rightMargin()))

            }
        }
    }
    
    func font() -> Font {
        return fontValue(for: field, with: colorScheme)
    }
    
    public func margin() -> CGFloat {
        return self.field?.margin() ?? 0.0
    }
    
    public func topMargin() -> CGFloat {
        return self.field?.topMargin() ?? 0.0
    }

    public func bottomMargin() -> CGFloat {
        return self.field?.bottomMargin() ?? 0.0
    }

    public func leftMargin() -> CGFloat {
        return self.field?.leftMargin() ?? 0.0
    }

    public func rightMargin() -> CGFloat {
        return self.field?.rightMargin() ?? 0.0
    }

    func foreground() -> Color {
        return colorValue(of: "foreground-color", for: field, with: colorScheme)
    }

    func background() -> Color {
        return colorValue(of: "background-color", for: field, with: colorScheme)
    }
}

struct PickerView: View {
    
    @ObservedObject var viewModel: PickerViewModel

    var body: some View {
        VStack {
            Text("Demo Project")
        }
        .photosPicker(isPresented: $viewModel.shouldPresentPhotoPicker, selection: $viewModel.selectedPickerItem)
    }
}

class PickerViewModel: ObservableObject {
    @Published var shouldPresentPhotoPicker = false
    @Published var selectedPickerItem: PhotosPickerItem?

    func saveTheRecord() {
        /// Make an async call, and wait
        shouldPresentPhotoPicker = true // Shows the Picker
    }
}

#Preview {
    ImagePickerView()
}
