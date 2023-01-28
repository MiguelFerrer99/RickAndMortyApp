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
}

final class DefaultEpisodesCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: EpisodesExternalDependenciesResolver
    private lazy var dependencies: DefaultEpisodesDependenciesResolver = {
        DefaultEpisodesDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
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
}

private extension DefaultEpisodesCoordinator {
    struct DefaultEpisodesDependenciesResolver: EpisodesDependenciesResolver {
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
