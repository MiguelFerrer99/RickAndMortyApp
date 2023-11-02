//
//  CharactersExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit

protocol CharactersExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolveCharactersCoordinator() -> CharactersCoordinator
    func resolveCharacterDetailCoordinator() -> CharacterDetailCoordinator
}

extension CharactersExternalDependenciesResolver {
    func resolveCharactersCoordinator() -> CharactersCoordinator {
        DefaultCharactersCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
