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
    func resolve(with info: EpisodesViewModelRepresentable) -> EpisodesViewController
    func resolve(with info: EpisodesViewModelRepresentable) -> EpisodesViewModel
    func resolve() -> EpisodesUseCase
    func resolve() -> EpisodesRepository
}

extension EpisodesDependenciesResolver {
    func resolve(with info: EpisodesViewModelRepresentable) -> EpisodesViewController {
        EpisodesViewController(dependencies: self, info: info)
    }
    
    func resolve(with info: EpisodesViewModelRepresentable) -> EpisodesViewModel {
        EpisodesViewModel(dependencies: self, info: info)
    }
    
    func resolve() -> EpisodesUseCase {
        DefaultEpisodesUseCase(dependencies: self)
    }
    
    func resolve() -> EpisodesRepository {
        DefaultEpisodesRepository(dependencies: self)
    }
}
