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
    func resolve() -> EpisodesUseCase
    func resolve() -> EpisodesRepository
}

extension EpisodesDependenciesResolver {
    func resolve() -> EpisodesViewController {
        EpisodesViewController(dependencies: self)
    }
    
    func resolve() -> EpisodesUseCase {
        DefaultEpisodesUseCase(dependencies: self)
    }
    
    func resolve() -> EpisodesRepository {
        DefaultEpisodesRepository(dependencies: self)
    }
}
