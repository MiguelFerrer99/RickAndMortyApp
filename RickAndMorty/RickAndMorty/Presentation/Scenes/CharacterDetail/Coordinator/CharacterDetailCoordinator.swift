//
//  CharacterDetailCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol CharacterDetailCoordinator: Coordinator {
    func setInfo(_ info: CharacterDetailRepresentable)
}

final class DefaultCharacterDetailCoordinator {
    var navigationController: UINavigationController
    private var info: CharacterDetailRepresentable?
    private let externalDependencies: CharacterDetailExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: CharacterDetailExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultCharacterDetailCoordinator: CharacterDetailCoordinator {
    func start() {
        guard let info else { return }
        let viewController: CharacterDetailViewController = dependencies.resolve(with: info)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setInfo(_ info: CharacterDetailRepresentable) {
        self.info = info
    }
}

private extension DefaultCharacterDetailCoordinator {
    struct Dependencies: CharacterDetailDependenciesResolver {
        let externalDependencies: CharacterDetailExternalDependenciesResolver
        let coordinator: CharacterDetailCoordinator
        
        var external: CharacterDetailExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> CharacterDetailCoordinator {
            coordinator
        }
    }
}
