//
//  RepositoryRow.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 01/03/23.
//

import Foundation

import SwiftUI
import Combine
import URLImage

struct RepositoryRow: View {
    @Binding var record: DetailPageObject

    var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(record.name)
                    .font(Font.system(size: 20).bold())
                Text("Contributors:")
                    .font(Font.system(size: 16))
                    .underline(color: Color.gray)
                Text(record.contributors.map { $0.name }.joined(separator: ", "))
                    .font(Font.system(size: 14))
                Text("Languages:")
                    .font(Font.system(size: 16))
                    .underline(color: Color.gray)
                Text(record.languages.joined(separator: ", "))
                    .font(Font.system(size: 14))
           }
    }
}
