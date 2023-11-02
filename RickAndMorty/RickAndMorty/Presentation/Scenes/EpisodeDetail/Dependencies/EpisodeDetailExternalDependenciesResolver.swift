//
//  EpisodeDetailExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol EpisodeDetailExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> EpisodeDetailCoordinator
}

extension EpisodeDetailExternalDependenciesResolver {
    func resolve() -> EpisodeDetailCoordinator {
        DefaultEpisodeDetailCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
