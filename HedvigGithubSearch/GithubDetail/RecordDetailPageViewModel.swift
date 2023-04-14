//
//  RecordDetailPageViewModel.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 27/02/23.
//

import SwiftUI
import Combine

class RecordDetailPageViewModel: ObservableObject {
    @Published var cellData: CellObject
    @Published var reposInfo: [DetailPageObject] = []
    var showActivityIndicator = true
    
    private var cancellables: [AnyCancellable] = []
    private let dataProvider: APICall
    let appearRecord = PassthroughSubject<Void, Never>()

    init(cellData:CellObject, dataProvider: APICall) {
        self.cellData = cellData
        self.dataProvider = dataProvider
        configureInputToGetOutput()
    }
}

extension RecordDetailPageViewModel: RecordDetailsPageViewModelType {
    
    private func configureInputToGetOutput() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input = RecordDetailVMInput(appear: appearRecord.eraseToAnyPublisher())
        change(input: input)
            .sink {[unowned self] detailsPageState in
                switch detailsPageState {
                case .success(let result):
                    self.showActivityIndicator = false
                    self.reposInfo.append(contentsOf: result)
                case .failure(_):
                    self.showActivityIndicator = true
                    self.reposInfo = []
               case.loading:
                    self.showActivityIndicator = true
                    self.reposInfo = []
                }
            }.store(in: &cancellables)
    }
   
    internal func change(input: RecordDetailVMInput) -> AnyPublisher<RecordPageDetailsState, Never> {
        
        let reposDetails =
        input.appear
        .flatMap({[unowned self] _ in self.dataProvider.repos(for: cellData.title) })
        .map({ repos in
            Publishers.MergeMany(repos.map({[unowned self] singleRepo in
                
                Publishers.Zip(self.dataProvider.contributors(for: self.cellData.title, repoName: singleRepo.name), self.dataProvider.languages(for: self.cellData.title, repoName: singleRepo.name))
                
                    .map { (contributors, languages) -> DetailPageObject in
                        var singleDetailObject = DetailPageObject(repo: singleRepo)
                        singleDetailObject.contributors = contributors
                        singleDetailObject.languages = languages
                        return singleDetailObject
                    }
            }))
            .collect(repos.count)
        })
        .switchToLatest()
        .map { detailPageObjects -> RecordPageDetailsState in
            RecordPageDetailsState.success(detailPageObjects)
        }
        .replaceError(with:RecordPageDetailsState.success([]))
        .eraseToAnyPublisher()

        let loading: AnyPublisher<RecordPageDetailsState, Never> = input.appear.map({_ in RecordPageDetailsState.loading }).eraseToAnyPublisher()
        let result = Publishers.Merge(loading, reposDetails).removeDuplicates()
        return result.eraseToAnyPublisher()
    }
}
