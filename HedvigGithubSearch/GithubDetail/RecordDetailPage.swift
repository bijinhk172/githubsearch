//
//  RecordDetailPage.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 27/02/23.
//

import SwiftUI

struct RecordDetailPage: View {
    @ObservedObject private var theViewModel: RecordDetailPageViewModel

    init(viewmodel: RecordDetailPageViewModel) {
        theViewModel = viewmodel
    }
    
    var body: some View {
        ZStack {
            List($theViewModel.reposInfo, id:\.self) { $singleRepo in
                RepositoryRow(record: $singleRepo)
                }
                .onAppear {
                    theViewModel.appearRecord.send()
                }
                .navigationBarTitle(Text("Repositories"), displayMode: .inline)
            if theViewModel.showActivityIndicator {
                ProgressView()
                    .scaleEffect(2.0, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
    }
}

struct RecordDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        RecordDetailPage(viewmodel: RecordDetailPageViewModel(cellData: CellObject(id: 1, title: "title", subtitle: "subtitle", imageValue: "placeholder"), dataProvider: DataFetcher(apiService: APIService())))
    }
}
