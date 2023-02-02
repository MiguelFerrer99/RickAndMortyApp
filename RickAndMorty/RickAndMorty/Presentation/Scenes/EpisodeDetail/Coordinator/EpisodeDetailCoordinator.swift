//
//  EpisodeDetailCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol EpisodeDetailCoordinator {
    func start(with representable: EpisodeDetailRepresentable)
    func back()
}

final class DefaultEpisodeDetailCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: EpisodeDetailExternalDependenciesResolver
    private lazy var dependencies: DefaultEpisodeDetailDependenciesResolver = {
        DefaultEpisodeDetailDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
    init(externalDependencies: EpisodeDetailExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultEpisodeDetailCoordinator: EpisodeDetailCoordinator {
    func start(with representable: EpisodeDetailRepresentable) {
        dependencies.representable = representable
        navigationController.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}

private extension DefaultEpisodeDetailCoordinator {
    struct DefaultEpisodeDetailDependenciesResolver: EpisodeDetailDependenciesResolver {
        let externalDependencies: EpisodeDetailExternalDependenciesResolver
        let coordinator: EpisodeDetailCoordinator
        var representable: EpisodeDetailRepresentable?
        
        var external: EpisodeDetailExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> EpisodeDetailCoordinator {
            coordinator
        }
        
        func resolve() -> EpisodeDetailViewModel {
            EpisodeDetailViewModel(dependencies: self, representable: representable)
        }
    }
}
