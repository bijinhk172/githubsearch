//
//  GithubSearchVMTests.swift
//  HedvigGithubSearchTests
//
//  Created by Bijin Karim on 01/03/23.
//

import XCTest
import Combine
@testable import HedvigGithubSearch

class GithubSearchVMTests: XCTestCase {

    func test_InitialValues() {
        let searchVM = GithubSearchViewModel(dataProvider: DataFetcher(apiService: APIService()))
        XCTAssertFalse(searchVM.activityIndicatorShouldShow)
        XCTAssertEqual(searchVM.searchPageState, SearchPageUI.beforeSearch)
        XCTAssertEqual(searchVM.allCellData.count, 0)
        XCTAssertEqual(searchVM.searchType, SearchType.user)
    }

    func test_GetUsersWhenTextEntered() {
        let apiService = APIServiceMock()
        let searchVM = GithubSearchViewModel(dataProvider: DataFetcher(apiService: apiService))

        let users = GithubResponse.loadFromFile("users.json")
        apiService.responses["/search/users"] = users
        searchVM.searchRecord.send("superman")
        
        if waiterResult() == XCTWaiter.Result.timedOut {
            XCTAssertTrue(searchVM.allCellData.count > 0)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_showError_whenNoUsersFound() {
        let apiService = APIServiceMock()
        let searchVM = GithubSearchViewModel(dataProvider: DataFetcher(apiService: apiService))
        apiService.responses["/search/users"] = GithubResponse(items: [])

        searchVM.searchRecord.send("superman")

        if waiterResult() == XCTWaiter.Result.timedOut {
            XCTAssertTrue(searchVM.allCellData.count == 0)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func test_showError_whenDataLoadingFailed() {
        let apiService = APIServiceMock()
        let searchVM = GithubSearchViewModel(dataProvider: DataFetcher(apiService: apiService))

        searchVM.searchRecord.send("superman")

        if waiterResult() == XCTWaiter.Result.timedOut {
            XCTAssertFalse(searchVM.activityIndicatorShouldShow)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}

extension GithubSearchVMTests {
    func waiterResult() -> XCTWaiter.Result {
        let exp = expectation(description: "Test after 0.4 second")
        return XCTWaiter.wait(for: [exp], timeout: 0.4)
    }
}

extension Decodable {
    static func loadFromFile(_ filename: String) -> Self {
        do {
            let path = Bundle.main.path(forResource: filename, ofType: nil)!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
