//
//  CharactersCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import UIKit

protocol CharactersCoordinator: Coordinator {
    func setInfo(_ info: CharactersViewModelRepresentable)
    func openCharacter(with info: CharacterDetailRepresentable)
}

final class DefaultCharactersCoordinator {
    var navigationController: UINavigationController
    private var info: CharactersViewModelRepresentable?
    private let externalDependencies: CharactersExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: CharactersExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultCharactersCoordinator: CharactersCoordinator {
    func start() {
        guard let info else { return }
        let viewController: CharactersViewController = dependencies.resolve(with: info)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setInfo(_ info: CharactersViewModelRepresentable) {
        self.info = info
    }
    
    func openCharacter(with info: CharacterDetailRepresentable) {
        let coordinator: CharacterDetailCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
    }
}

private extension DefaultCharactersCoordinator {
    struct Dependencies: CharactersDependenciesResolver {
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
