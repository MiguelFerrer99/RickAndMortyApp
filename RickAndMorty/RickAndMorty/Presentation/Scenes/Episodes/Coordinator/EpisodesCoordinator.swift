//
//  EpisodesCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol EpisodesCoordinator {
    func start(with representable: EpisodesViewModelRepresentable)
    func back()
    func openEpisode(_ representable: EpisodeDetailRepresentable)
}

final class DefaultEpisodesCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: EpisodesExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: EpisodesExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultEpisodesCoordinator: EpisodesCoordinator {
    func start(with representable: EpisodesViewModelRepresentable) {
        dependencies.representable = representable
        navigationController.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func openEpisode(_ representable: EpisodeDetailRepresentable) {
        let coordinator: EpisodeDetailCoordinator = dependencies.external.resolveEpisodeDetailCoordinator()
        coordinator.start(with: representable)
    }
}

private extension DefaultEpisodesCoordinator {
    struct Dependencies: EpisodesDependenciesResolver {
        let externalDependencies: EpisodesExternalDependenciesResolver
        let coordinator: EpisodesCoordinator
        var representable: EpisodesViewModelRepresentable?
        
        var external: EpisodesExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> EpisodesCoordinator {
            coordinator
        }
        
        func resolve() -> EpisodesViewModel {
            EpisodesViewModel(dependencies: self, representable: representable)
        }
    }
}
