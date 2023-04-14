//
//  GithubSearchViewModel.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 23/02/23.
//

import Foundation

import SwiftUI
import Combine

enum SearchType: String, CaseIterable, Equatable {
    case user = "User"
    case org = "Organization"
}

protocol GithubSearchViewModelProtocol {
    func change(input: GithubSearchVMInput) -> AnyPublisher<RecordsSearchResultState, Never>
}

final class GithubSearchViewModel: GithubSearchViewModelProtocol, ObservableObject {

    @Published var allCellData: [CellObject] = []
    @Published var searchType = SearchType.user
    @Published var currentText: String = ""

    var searchPageState = SearchPageUI.beforeSearch
    var activityIndicatorShouldShow = false
    
    let searchRecord = PassthroughSubject<String, Never>()
    private var cancellables: [AnyCancellable] = []
    private(set) var dataProvider: APICall 
    
    init(dataProvider: APICall) {
        self.dataProvider = dataProvider
        configureInputToGetOutput()
    }
}

private extension GithubSearchViewModel {
    func configureInputToGetOutput() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let gitHubVMInput = GithubSearchVMInput(searchRecord: searchRecord.eraseToAnyPublisher())
        change(input: gitHubVMInput)
            .sink { [weak self ]dataState in
                self?.displayPageFor(dataState: dataState)
            }.store(in: &cancellables)
    }
    
    func displayPageFor(dataState: RecordsSearchResultState) {
        switch dataState {
        case .initial:
            allCellData = []
            searchPageState = .beforeSearch
            activityIndicatorShouldShow = false
        case .fetching:
            allCellData = []
            searchPageState = .loading
            activityIndicatorShouldShow = true
        case .empty:
            allCellData = []
            searchPageState = .zeroRecords
            activityIndicatorShouldShow = false
        case .failed(let error):
            allCellData = []
            searchPageState = .searchError(error.localizedDescription)
            activityIndicatorShouldShow = false
        case .success(let cellObjects):
            allCellData = cellObjects
            searchPageState = .recordsPresent
            activityIndicatorShouldShow = false
        }
    }

}

extension GithubSearchViewModel: RecordsSearchViewModelType {
    
    private func cellObjects(for records:[Record]) -> [CellObject] {
        return records.map { CellObjectProvider.getCellObject(from: $0) }
    }

    func change(input: GithubSearchVMInput) -> AnyPublisher<RecordsSearchResultState, Never> {
        let searchInput = input.searchRecord
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
        let initialState: AnyPublisher<RecordsSearchResultState, Never> = Just(.initial).eraseToAnyPublisher()
        let emptySearchString: AnyPublisher<RecordsSearchResultState, Never> = searchInput
            .filter({ $0.isEmpty })
            .map({ _ in .initial })
            .eraseToAnyPublisher()
        let idle: AnyPublisher<RecordsSearchResultState, Never> = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()

        let records = searchInput
            .filter({ !$0.isEmpty })
            .flatMap({[unowned self] searchString in
                self.getCellRecords(searchString: searchString)
            })
            .map({ cellObjectsAndError -> RecordsSearchResultState in
                switch cellObjectsAndError {
                    case .success([]): return .empty
                    case .success(let cellObjects): return .success(cellObjects)
                    case .failure(let error): return .failed(error)
                }
            })
            .eraseToAnyPublisher()
        
        return Publishers.Merge(idle, records).removeDuplicates().eraseToAnyPublisher()
    }
    
    private func getCellRecords(searchString: String) -> AnyPublisher<Result<[CellObject], Error>, Never> {
        if searchType == .user {
            return self.dataProvider.searchUsers(with: searchString)
                .map { usersAndError -> Result<[CellObject], Error> in
                    switch usersAndError {
                        case .success(let users): return .success(self.cellObjects(for: users))
                        case .failure(let error): return .failure(error)
                    }
                }.eraseToAnyPublisher()
        } else {
            return self.dataProvider.searchOrganistion(with: searchString)
                .map { orgsAndError -> Result<[CellObject], Error> in
                    switch orgsAndError {
                        case .success(let organisations): return .success(self.cellObjects(for: organisations))
                        case .failure(let error): return .failure(error)
                    }
                }.eraseToAnyPublisher()
        }
    }
}
