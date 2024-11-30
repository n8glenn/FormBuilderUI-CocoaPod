//
//  SignatureView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI

struct Line {
    var points: [CGPoint]
}

struct SignatureView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.styleName) var styleName

    var field:FBSignatureField? = nil
    @State private var lines: [Line] = []
    
    var canvas:some View {
        return Canvas {ctx, size in
            for line in lines {
                var path = Path()
                path.addLines(line.points)
                ctx.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: field?.style(colorScheme: colorScheme)?.value(forKey: "line-width") as? CGFloat ?? 5.0, lineCap: .round, lineJoin: .round))
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                let position = value.location
                
                if value.translation == .zero {
                    lines.append(Line(points: [position]))
                } else {
                    guard let lastIdx = lines.indices.last else {
                        return
                    }
                    lines[lastIdx].points.append(position)
                }
            }))
    }
    
    var body: some View {

        HStack {
            VStack {
                if (field?.caption != nil && field?.caption != "") {
                    Text(field?.caption ?? "")
                        .frame(minWidth: .none, maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                ZStack {
                    Canvas {ctx, size in
                        
                        var path = Path()
                        path.addLines([CGPoint(x: 5, y: size.height - 20), CGPoint(x: 15, y: size.height - 10)])
                        path.addLines([CGPoint(x: 5, y: size.height - 10), CGPoint(x: 15, y: size.height - 20)])
                        path.addLines([CGPoint(x: 20,  y: size.height - 10), CGPoint(x: size.width - 10, y: size.height - 10)])
                        ctx.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: 0.5, lineCap: .round, lineJoin: .round))
                    }
                    .padding(EdgeInsets(top: topMargin(),
                                        leading: leftMargin(),
                                        bottom: bottomMargin(),
                                        trailing: rightMargin()))
                    .background(.white)
                    
                    Canvas {ctx, size in
                        for line in lines {
                            var path = Path()
                            path.addLines(line.points)
                            ctx.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: field?.style(colorScheme: colorScheme)?.value(forKey: "line-width") as? CGFloat ?? 1.0, lineCap: .round, lineJoin: .round))
                        }
                    }
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            let position = value.location
                            
                            if value.translation == .zero {
                                lines.append(Line(points: [position]))
                            } else {
                                guard let lastIdx = lines.indices.last else {
                                    return
                                }
                                lines[lastIdx].points.append(position)
                            }
                        })
                            .onEnded({ value in
                                
                                let newImage = self.canvas.frame(width: self.width(field: field), height: self.field?.height() ?? 0).snapshot()
                                //UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
                                field?.hasInput = true
                                field?.input = newImage
                                /*
                                 if let image = self.field?.input as? UIImage {
                                 UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                 }
                                 */
                            })
                    )
                    .padding(EdgeInsets(top: topMargin(),
                                        leading: leftMargin(),
                                        bottom: bottomMargin(),
                                        trailing: rightMargin()))
                    .border(.black)
                    .background(.clear)
                    
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
            
            VStack {
                if self.field?.required ?? false {
                    Spacer()
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.red)
                        .shadow(radius: 2.5)
                        .padding(EdgeInsets(top: topMargin(),
                                            leading: leftMargin(),
                                            bottom: bottomMargin(),
                                            trailing: rightMargin()))
                }
                Spacer()
                Button {
                    // clear the signature view.
                    clear()
                } label: {
                    Image(systemName: "trash")
                }
                .frame(width: 10, height: 10, alignment: .bottomTrailing)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 5))
            }
            .frame(minHeight: .none, maxHeight: .infinity)

        }
    }
    
    func clear() {
        
        lines = []
        field?.hasInput = false
        field?.input = nil
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

    func height() -> CGFloat {
        return floatValue(of: "height", for: field, with: colorScheme) ?? 50.0
    }
}

#Preview {
    SignatureView()
}
