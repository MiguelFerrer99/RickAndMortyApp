//
//  EpisodesExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol EpisodesExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> EpisodesCoordinator
    func resolve() -> EpisodeDetailCoordinator
}

extension EpisodesExternalDependenciesResolver {
    func resolve() -> EpisodesCoordinator {
        DefaultEpisodesCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
