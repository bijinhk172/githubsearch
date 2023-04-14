//
//  APICall.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 24/02/23.
//

import Foundation

import Foundation
import Combine
import UIKit.UIImage


protocol APICall {

    func searchUsers(with name: String) -> AnyPublisher<Result<[Record], Error>, Never>
    func searchOrganistion(with name: String) -> AnyPublisher<Result<[Record], Error>, Never>
    func repos(for loginName: String) -> AnyPublisher<[Repo], Error>
    func contributors(for loginName: String, repoName: String) -> AnyPublisher<[Contributor], Never>
    func languages(for loginName: String, repoName: String) -> AnyPublisher<[String], Never>
}

final class DataFetcher: APICall {

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    static var limitedOperationsQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    func searchUsers(with name: String) -> AnyPublisher<Result<[Record], Error>, Never> {
        return apiService
            .load(Resource<GithubResponse>.records(searchString: name))
            .map({ (result: Result<GithubResponse, NetworkError>) -> Result<[Record], Error> in
                switch result {
                case .success(let response): return .success(response.items)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func searchOrganistion(with name: String) -> AnyPublisher<Result<[Record], Error>, Never> {
        return apiService
            .load(Resource<Record>.record(searchString: name))
            .map({ (result: Result<Record, NetworkError>) -> Result<[Record], Error> in
                switch result {
                case .success(let response): return .success([response])
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func repos(for loginName: String) -> AnyPublisher<[Repo], Error> {
        return apiService
            .load(Resource<[Repo]>.repositories(loginName: loginName))
            .flatMap({ (result: Result<[Repo], NetworkError>) -> AnyPublisher<[Repo], Error> in
                switch result {
                case .success(let records): return Just(records).setFailureType(to: Error.self).eraseToAnyPublisher()
                case .failure(let error): return Fail(error: error).eraseToAnyPublisher()
                }
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func contributors(for loginName: String, repoName: String) -> AnyPublisher<[Contributor], Never> {
        return apiService
            .load(Resource<[Contributor]>.contributors(loginName: loginName, repoName: repoName))
            .map({ (result: Result<[Contributor], NetworkError>) -> [Contributor] in
                switch result {
                case .success(let records): return records
                case .failure(_): return []
                }
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
        func languages(for loginName: String, repoName: String) -> AnyPublisher<[String], Never> {
        return apiService
            .load(Resource<[String:Int]>.languages(loginName: loginName, repoName: repoName))
            .map({ (result: Result<[String:Int], NetworkError>) -> [String] in
                switch result {
                case .success(let record):  return record.keys.map { $0 }
                case .failure(_): return []
                }
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
