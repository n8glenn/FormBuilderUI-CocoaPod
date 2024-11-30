//
//  ImageView.swift
//
//
//  Created by Nathan Glenn on 12/19/23.
//

import SwiftUI

struct ImageView: View {
    
    var field:FBImageField? = nil
    @Environment(\.styleName) var styleName

    var body: some View {
        Image(field?.data as? String ?? "")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    ImageView()
}
