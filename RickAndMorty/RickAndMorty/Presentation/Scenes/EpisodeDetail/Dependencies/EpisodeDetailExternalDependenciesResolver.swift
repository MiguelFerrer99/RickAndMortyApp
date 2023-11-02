//
//  EpisodeDetailExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol EpisodeDetailExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolveEpisodeDetailCoordinator() -> EpisodeDetailCoordinator
}

extension EpisodeDetailExternalDependenciesResolver {
    func resolveEpisodeDetailCoordinator() -> EpisodeDetailCoordinator {
        DefaultEpisodeDetailCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
