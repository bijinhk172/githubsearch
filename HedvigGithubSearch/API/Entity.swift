//
//  Entity.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 24/02/23.
//

import Combine
import Foundation

struct Resource<T: Decodable> {
    let url: URL
    let parameters: [String: CustomStringConvertible]
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        var theRequest = URLRequest(url: url)
        theRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return theRequest
    }

    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}

extension Resource {

    static func records(searchString: String) -> Resource<GithubResponse> {
        let url = ServiceURLs.base.appendingPathComponent("/search/users")
        let parameters: [String : CustomStringConvertible] = ["q": searchString]
        return Resource<GithubResponse>(url: url, parameters: parameters)
    }

    static func record(searchString: String) -> Resource<Record> {
        let url = ServiceURLs.base.appendingPathComponent("/orgs/\(searchString)")
        return Resource<Record>(url: url)
    }
    static func repositories(loginName: String) -> Resource<[Repo]> {
        let url = ServiceURLs.base.appendingPathComponent("/users/\(loginName)/repos")
        return Resource<[Repo]>(url: url)
    }
    static func contributors(loginName: String, repoName:String) -> Resource<[Contributor]> {
        let url = ServiceURLs.base.appendingPathComponent("/repos/\(loginName)/\(repoName)/contributors")
        return Resource<[Contributor]>(url: url)
    }
    static func languages(loginName: String, repoName:String) -> Resource<[String:Int]> {
        let url = ServiceURLs.base.appendingPathComponent("/repos/\(loginName)/\(repoName)/languages")
        return Resource<[String:Int]>(url: url)
    }
}

