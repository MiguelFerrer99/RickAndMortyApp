//
//  CharactersCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit

protocol CharactersCoordinator {
    func start()
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
    func start() {
        navigationController.pushViewController(dependencies.resolve(), animated: true)
    }
}

private extension DefaultCharactersCoordinator {
    struct DefaultCharactersDependenciesResolver: CharactersDependenciesResolver {
        let externalDependencies: CharactersExternalDependenciesResolver
        let coordinator: CharactersCoordinator
        
        var external: CharactersExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> CharactersCoordinator {
            coordinator
        }
    }
}
