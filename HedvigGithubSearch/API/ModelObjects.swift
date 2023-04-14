//
//  ModelObjects.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 25/02/23.
//

import Foundation
import UIKit.UIImage
import Combine

struct CellObject {
    let id: Int
    let title: String
    let subtitle: String
    let imageValue: String?

    init(id: Int, title: String, subtitle: String, imageValue: String?) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageValue = imageValue
    }
}

extension CellObject: Hashable {
    static func == (lhs: CellObject, rhs: CellObject) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CellObjectProvider {
    static func getCellObject(from record: Record) -> CellObject {
        return CellObject(id: record.id,
                          title: record.name,
                          subtitle: "",
                          imageValue: record.iconImage)
    }
}

struct DetailPageObject {
    var id: Int
    var name: String
    var description: String
    var contributors: [Contributor] = []
    var languages : [String] = []
    
    init(repo: Repo) {
        self.id = repo.id
        self.name = repo.name
        self.description = ""
    }
}

extension DetailPageObject: Hashable {
    static func == (lhs: DetailPageObject, rhs: DetailPageObject) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

