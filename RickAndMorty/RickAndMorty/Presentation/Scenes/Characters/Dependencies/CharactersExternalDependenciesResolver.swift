//
//  CharactersExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit

protocol CharactersExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> CharactersCoordinator
    func resolve() -> CharacterDetailCoordinator
}

extension CharactersExternalDependenciesResolver {
    func resolve() -> CharactersCoordinator {
        DefaultCharactersCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
