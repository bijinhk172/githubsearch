//
//  PlaceHolderView.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 01/03/23.
//

import SwiftUI

struct PlaceHolderView: View {
    @State var currentPageStatus: SearchPageUI
    var body: some View {
        VStack(spacing: 10) {
            Image("githubSearch")
            Text(currentPageStatus.titleText)
            Text(currentPageStatus.subtitleText)
        }
    }
}

enum SearchPageUI {
    case beforeSearch
    case loading
    case zeroRecords
    case searchError(String)
    case recordsPresent
    
    var titleText: String {
        switch self {
        case .beforeSearch:
             return "Type in and search"
        case .loading, .recordsPresent:
            return ""
        case .zeroRecords:
            return "No records found!"
        case .searchError(let errorDetails):
            return errorDetails
        }
    }
    
    var subtitleText: String {
        switch self {
        case .beforeSearch:
            return "Waiting for results to be shown"
        case .loading, .recordsPresent:
            return ""
        case .zeroRecords:
            return "Change the text and see..."
        case .searchError:
            return "Something is not right. Try again and if not working, please use customer service to update so that we can resolve the issue as soon as possible"
        }
    }
}

extension SearchPageUI: Equatable {
    static func ==(lhs: SearchPageUI, rhs: SearchPageUI) -> Bool {
        switch (lhs, rhs) {
        case (.beforeSearch, .beforeSearch), (.loading, .loading), (.recordsPresent, .recordsPresent), (.zeroRecords, .zeroRecords):
            return true
        case (.searchError(let lhsValue), .searchError(let rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}
