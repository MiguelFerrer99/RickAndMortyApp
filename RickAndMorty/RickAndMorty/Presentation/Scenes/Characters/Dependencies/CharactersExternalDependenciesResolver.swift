//
//  CharactersExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit

protocol CharactersExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveCharactersCoordinator() -> CharactersCoordinator
}

extension CharactersExternalDependenciesResolver {
    func resolveCharactersCoordinator() -> CharactersCoordinator {
        DefaultCharactersCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
