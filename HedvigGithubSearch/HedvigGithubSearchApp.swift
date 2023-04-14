//
//  HedvigGithubSearchApp.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 23/02/23.
//

import SwiftUI

@main
struct HedvigGithubSearchApp: App {
    var body: some Scene {
        WindowGroup {
            let apiCallInstance = DataFetcher(apiService: APIService())
            let viewModel = GithubSearchViewModel(dataProvider: apiCallInstance)
            GithubSearchView(viewModel: viewModel)
        }
    }
}
