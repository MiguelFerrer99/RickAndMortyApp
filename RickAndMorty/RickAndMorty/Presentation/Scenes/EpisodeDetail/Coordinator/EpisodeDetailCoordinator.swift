//
//  EpisodeDetailCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol EpisodeDetailCoordinator: Coordinator {
    func setInfo(_ info: EpisodeDetailRepresentable)
}

final class DefaultEpisodeDetailCoordinator {
    var navigationController: UINavigationController
    private var info: EpisodeDetailRepresentable?
    private let externalDependencies: EpisodeDetailExternalDependenciesResolver
    private lazy var dependencies: Dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: EpisodeDetailExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultEpisodeDetailCoordinator: EpisodeDetailCoordinator {
    func start() {
        guard let info else { return }
        let viewController: EpisodeDetailViewController = dependencies.resolve(with: info)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setInfo(_ info: EpisodeDetailRepresentable) {
        self.info = info
    }
}

private extension DefaultEpisodeDetailCoordinator {
    struct Dependencies: EpisodeDetailDependenciesResolver {
        let externalDependencies: EpisodeDetailExternalDependenciesResolver
        let coordinator: EpisodeDetailCoordinator
        
        var external: EpisodeDetailExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> EpisodeDetailCoordinator {
            coordinator
        }
    }
}
