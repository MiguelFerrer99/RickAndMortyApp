//
//  CommonExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer on 2/11/23.
//

import UIKit

protocol CommonExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolve() -> APIService
    func resolve() -> ImageCacheManager
}
