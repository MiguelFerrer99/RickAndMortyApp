//
//  EpisodesCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol EpisodesCoordinator: Coordinator {
    func setInfo(_ info: EpisodesViewModelRepresentable)
    func openEpisode(with info: EpisodeDetailRepresentable)
}

final class DefaultEpisodesCoordinator {
    var navigationController: UINavigationController
    private var info: EpisodesViewModelRepresentable?
    private let externalDependencies: EpisodesExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: EpisodesExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultEpisodesCoordinator: EpisodesCoordinator {
    func start() {
        guard let info else { return }
        let viewController: EpisodesViewController = dependencies.resolve(with: info)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setInfo(_ info: EpisodesViewModelRepresentable) {
        self.info = info
    }
    
    func openEpisode(with info: EpisodeDetailRepresentable) {
        let coordinator: EpisodeDetailCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
    }
}

private extension DefaultEpisodesCoordinator {
    struct Dependencies: EpisodesDependenciesResolver {
        let externalDependencies: EpisodesExternalDependenciesResolver
        let coordinator: EpisodesCoordinator
        
        var external: EpisodesExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> EpisodesCoordinator {
            coordinator
        }
    }
}
