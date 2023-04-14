//
//  ImageProvider.swift
//  HedvigGithubSearch
//
//  Created by Bijin Karim on 25/02/23.
//

import Foundation

import Foundation
import UIKit.UIImage
import Combine

protocol ImageProviderProtocol: AnyObject {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

final class ImageProvider: ImageProviderProtocol {

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .print("Image loading \(url):")//remove logging
            .eraseToAnyPublisher()
    }
}
