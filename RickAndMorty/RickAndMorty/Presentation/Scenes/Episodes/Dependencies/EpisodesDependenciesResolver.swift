//
//  EpisodesDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol EpisodesDependenciesResolver {
    var external: EpisodesExternalDependenciesResolver { get }
    func resolve() -> EpisodesCoordinator
    func resolve() -> EpisodesViewController
    func resolve() -> EpisodesViewModel
}

extension EpisodesDependenciesResolver {
    func resolve() -> EpisodesViewController {
        EpisodesViewController(dependencies: self)
    }
}
