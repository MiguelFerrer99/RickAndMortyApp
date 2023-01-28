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
    func resolve() -> CharactersUseCase
    func resolve() -> CharactersRepository
}

extension CharactersDependenciesResolver {
    func resolve() -> CharactersViewController {
        CharactersViewController(dependencies: self)
    }
    
    func resolve() -> CharactersUseCase {
        DefaultCharactersUseCase(dependencies: self)
    }
    
    func resolve() -> CharactersRepository {
        DefaultCharactersRepository(dependencies: self)
    }
}
