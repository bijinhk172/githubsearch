//
//  ContentView.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 23/02/23.
//

import SwiftUI

struct GithubSearchView: View {
    @ObservedObject private var theViewModel: GithubSearchViewModel

    init(viewModel: GithubSearchViewModel) {
        theViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $theViewModel.searchType) {
                    ForEach(SearchType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: theViewModel.searchType) { _ in
                    theViewModel.allCellData = []
                    theViewModel.currentText = ""
                }
                Spacer().frame(height:10)
                
                GithubSeachBar(text: $theViewModel.currentText) { _ in
                    theViewModel.searchRecord.send(theViewModel.currentText)
                }
                Spacer()
                List($theViewModel.allCellData, id:\.self) { $cellData in
                        NavigationLink {
                            RecordDetailPage(viewmodel: RecordDetailPageViewModel(cellData: cellData, dataProvider: theViewModel.dataProvider))
                        } label: {
                            GithubSearchResultRow(record: $cellData)
                        }
                }.overlay {
                    if theViewModel.allCellData.isEmpty {
                        PlaceHolderView(currentPageStatus: theViewModel.searchPageState)
                        if theViewModel.activityIndicatorShouldShow {
                            ProgressView()
                                .scaleEffect(2.0, anchor: .center)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        }
                    }
                }
                Spacer()
                .navigationBarTitle(Text("Github Search"), displayMode: .inline)
        }
    }
    }

}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GithubSearchView(viewModel: GithubSearchViewModel(dataProvider: DataFetcher(apiService: APIService())))
    }
}
