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
    func resolve(with info: CharactersViewModelRepresentable) -> CharactersViewController
    func resolve(with info: CharactersViewModelRepresentable) -> CharactersViewModel
    func resolve() -> CharactersUseCase
    func resolve() -> CharactersRepository
}

extension CharactersDependenciesResolver {
    func resolve(with info: CharactersViewModelRepresentable) -> CharactersViewController {
        CharactersViewController(dependencies: self, info: info)
    }
    
    func resolve(with info: CharactersViewModelRepresentable) -> CharactersViewModel {
        CharactersViewModel(dependencies: self, info: info)
    }
    
    func resolve() -> CharactersUseCase {
        DefaultCharactersUseCase(dependencies: self)
    }
    
    func resolve() -> CharactersRepository {
        DefaultCharactersRepository(dependencies: self)
    }
}
