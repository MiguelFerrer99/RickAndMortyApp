//
//  CharactersCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit

protocol CharactersCoordinator {
    func start(with: [CharacterRepresentable])
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
    func start(with characters: [CharacterRepresentable]) {
        dependencies.characters = characters
        navigationController.pushViewController(dependencies.resolve(), animated: true)
    }
}

private extension DefaultCharactersCoordinator {
    struct DefaultCharactersDependenciesResolver: CharactersDependenciesResolver {
        let externalDependencies: CharactersExternalDependenciesResolver
        let coordinator: CharactersCoordinator
        var characters: [CharacterRepresentable]?
        
        var external: CharactersExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> CharactersCoordinator {
            coordinator
        }
        
        func resolve() -> CharactersViewModel {
            CharactersViewModel(dependencies: self, characters: characters!)
        }
    }
}
