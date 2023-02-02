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
    func resolve() -> CharacterDetailViewController
    func resolve() -> CharacterDetailViewModel
}

extension CharacterDetailDependenciesResolver {
    func resolve() -> CharacterDetailViewController {
        CharacterDetailViewController(dependencies: self)
    }
}
