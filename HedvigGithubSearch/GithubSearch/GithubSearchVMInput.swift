//
//  GithubSearchVMInput.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 24/02/23.
//

import Combine

struct GithubSearchVMInput {
    let searchRecord: AnyPublisher<String, Never>
}

enum RecordsSearchResultState {
    case initial
    case fetching
    case success([CellObject])
    case empty
    case failed(Error)
}

extension RecordsSearchResultState: Equatable {
    static func == (lhs: RecordsSearchResultState, rhs: RecordsSearchResultState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial): return true
        case (.fetching, .fetching): return true
        case (.success(let lhsRecords), .success(let rhsRecords)): return lhsRecords == rhsRecords
        case (.empty, .empty): return true
        case (.failed, .failed): return true
        default: return false
        }
    }
}

protocol RecordsSearchViewModelType {
    func change(input: GithubSearchVMInput) -> AnyPublisher<RecordsSearchResultState, Never>
}
