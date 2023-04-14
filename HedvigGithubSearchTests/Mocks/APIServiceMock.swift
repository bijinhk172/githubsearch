//
//  APIServiceMock.swift
//  HedvigGithubSearchTests
//
//  Created by Bijin Karim on 01/03/23.
//

import Combine
@testable import HedvigGithubSearch

class APIServiceMock: APIServiceProtocol {

    var responses = [String:Any]()

    func load<T: Decodable>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> {
        let result: Result<T, NetworkError>
        if let response = responses[resource.url.path] {
            result = .success(response as! T)
        } else {
            result = .failure(NetworkError.invalidRequest)
        }
        return Just<Result<T, NetworkError>>(result).eraseToAnyPublisher()
    }
}
