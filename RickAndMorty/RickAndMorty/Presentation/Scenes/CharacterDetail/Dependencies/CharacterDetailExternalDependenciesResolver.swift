//
//  CharacterDetailExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol CharacterDetailExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolveCharacterDetailCoordinator() -> CharacterDetailCoordinator
}

extension CharacterDetailExternalDependenciesResolver {
    func resolveCharacterDetailCoordinator() -> CharacterDetailCoordinator {
        DefaultCharacterDetailCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
