//
//  CharactersCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit

protocol CharactersCoordinator {
    func start(with representable: CharactersViewModelRepresentable)
    func back()
    func openCharacter(with representable: CharacterDetailRepresentable)
}

final class DefaultCharactersCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: CharactersExternalDependenciesResolver
    private lazy var dependencies: DefaultCharactersDependenciesResolver = {
        DefaultCharactersDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
    init(externalDependencies: CharactersExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultCharactersCoordinator: CharactersCoordinator {
    func start(with representable: CharactersViewModelRepresentable) {
        dependencies.representable = representable
        navigationController.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func openCharacter(with representable: CharacterDetailRepresentable) {
        let coordinator: CharacterDetailCoordinator = dependencies.external.resolveCharacterDetailCoordinator()
        coordinator.start(with: representable)
    }
}

private extension DefaultCharactersCoordinator {
    struct DefaultCharactersDependenciesResolver: CharactersDependenciesResolver {
        let externalDependencies: CharactersExternalDependenciesResolver
        let coordinator: CharactersCoordinator
        var representable: CharactersViewModelRepresentable?
        
        var external: CharactersExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> CharactersCoordinator {
            coordinator
        }
        
        func resolve() -> CharactersViewModel {
            CharactersViewModel(dependencies: self, representable: representable)
        }
    }
}
