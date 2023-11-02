//
//  CharacterDetailDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol CharacterDetailDependenciesResolver {
    var external: CharacterDetailExternalDependenciesResolver { get }
    func resolve() -> CharacterDetailCoordinator
    func resolve(with info: CharacterDetailRepresentable) -> CharacterDetailViewController
    func resolve(with info: CharacterDetailRepresentable) -> CharacterDetailViewModel
}

extension CharacterDetailDependenciesResolver {
    func resolve(with info: CharacterDetailRepresentable) -> CharacterDetailViewController {
        CharacterDetailViewController(dependencies: self, info: info)
    }
    
    func resolve(with info: CharacterDetailRepresentable) -> CharacterDetailViewModel {
        CharacterDetailViewModel(dependencies: self, info: info)
    }
}
