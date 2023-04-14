//
//  APIObjects.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 25/02/23.
//

import Foundation

struct Record: Hashable, Identifiable {
    var id: Int
    var name: String
    var email: String?
    var iconImage: String?
}

extension Record: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case email
        case iconImage = "avatar_url"
    }
}

struct GithubResponse: Decodable {
    var items: [Record]
}

struct Repo: Hashable, Identifiable {
    var id: Int
    var name: String
//    var description: String
}

extension Repo: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
//        case description
    }
}

struct Contributor: Hashable, Identifiable {
    var id: Int
    var name: String
    var profileImage: String
}

extension Contributor: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case profileImage = "avatar_url"
    }
}
