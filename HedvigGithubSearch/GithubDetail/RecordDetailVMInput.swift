//
//  RecordDetailVMInput.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 27/02/23.
//

import UIKit
import Combine

struct RecordDetailVMInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
}

enum RecordPageDetailsState {
    case loading
    case success([DetailPageObject])
    case failure(Error)
}

extension RecordPageDetailsState: Equatable {
    static func == (lhs: RecordPageDetailsState, rhs: RecordPageDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsDetail), .success(let rhsDetail)): return lhsDetail == rhsDetail
        case (.failure, .failure): return true
        default: return false
        }
    }
}

protocol RecordDetailsPageViewModelType {
    func change(input: RecordDetailVMInput) -> AnyPublisher<RecordPageDetailsState, Never>
}
