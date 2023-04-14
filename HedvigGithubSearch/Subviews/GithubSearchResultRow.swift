//
//  GithubSearchResultRow.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 23/02/23.
//

import SwiftUI
import Combine
import URLImage

struct GithubSearchResultRow: View {
    @Binding var record: CellObject

    var body: some View {
        HStack {
            if let theImage = record.imageValue,
                    let theURL = URL(string: theImage) {
                URLImage(theURL) { image in
                    image
                        .frame(width: 44, height: 44)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                }
            } else {
                Image(systemName: "photo")
                    .imageScale(.large)
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(record.title)
                    .font(Font.system(size: 20).bold())
                Text(record.title)
                    .font(Font.system(size: 12))
           }

            Spacer()
            }
            .frame(height: 60)
    }
}
