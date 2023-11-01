//
//  CharacterDetailCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol CharacterDetailCoordinator {
    func start(with representable: CharacterDetailRepresentable)
    func back()
}

final class DefaultCharacterDetailCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: CharacterDetailExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: CharacterDetailExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultCharacterDetailCoordinator: CharacterDetailCoordinator {
    func start(with representable: CharacterDetailRepresentable) {
        dependencies.representable = representable
        navigationController.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}

private extension DefaultCharacterDetailCoordinator {
    struct Dependencies: CharacterDetailDependenciesResolver {
        let externalDependencies: CharacterDetailExternalDependenciesResolver
        let coordinator: CharacterDetailCoordinator
        var representable: CharacterDetailRepresentable?
        
        var external: CharacterDetailExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> CharacterDetailCoordinator {
            coordinator
        }
        
        func resolve() -> CharacterDetailViewModel {
            CharacterDetailViewModel(dependencies: self, representable: representable)
        }
    }
}
