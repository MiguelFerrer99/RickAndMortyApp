//
//  CharacterDetailExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol CharacterDetailExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> CharacterDetailCoordinator
}

extension CharacterDetailExternalDependenciesResolver {
    func resolve() -> CharacterDetailCoordinator {
        DefaultCharacterDetailCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
