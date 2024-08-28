//
//  UserHeaderView.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 27/08/2024.
//

import SwiftUI

struct UserHeaderView: View {
    
    let photo: Photo
    let image: UIImage
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: 30, height: 30)
                .cornerRadius(50)
        }
    }
}

#Preview {
    UserHeaderView(photo: Photo(id: "", owner: "", farm: 99, secret: "", server: "", title: ""), image: UIImage())
}
