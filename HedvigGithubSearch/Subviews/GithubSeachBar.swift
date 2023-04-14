//
//  GithubSeachBar.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 23/02/23.
//

import SwiftUI
import Combine

struct GithubSeachBar: View {
    @Binding var text: String
    @State var action: (String) -> Void

    var body: some View {
        ZStack {
            HStack {
                TextField("Search", text: $text)
                    .onChange(of: text) {
                        action($0)
                    }
                    .padding([.leading, .trailing], 8)
                    .frame(height: 36)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding([.leading, .trailing], 16)
            }
            .frame(height: 36)
    }
}
