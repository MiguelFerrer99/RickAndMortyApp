//
//  CharactersDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit

protocol CharactersDependenciesResolver {
    var external: CharactersExternalDependenciesResolver { get }
    func resolve() -> CharactersCoordinator
    func resolve() -> CharactersViewController
    func resolve() -> CharactersViewModel
}

extension CharactersDependenciesResolver {
    func resolve() -> CharactersViewController {
        CharactersViewController(dependencies: self)
    }
}
