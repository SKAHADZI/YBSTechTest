//
//  TagBody.swift
//  YBSTechTest
//
//  Created by Senam Ahadzi on 28/08/2024.
//

import SwiftUI

struct TagBody: View {
    var tag: Tag
    var body: some View {
        Text(tag.raw)
            .padding()
            .background(Color.blue)
            .clipShape(.capsule)
    }
}

#Preview {
    TagBody(tag: Tag(id: "", author: "", authorname: "", raw: "dhsjlkhdss"))
}
