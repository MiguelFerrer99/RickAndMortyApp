//
//  EpisodesExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol EpisodesExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveAPIService() -> APIService
    func resolveImageCacheManager() -> ImageCacheManager
    func resolveEpisodesCoordinator() -> EpisodesCoordinator
    func resolveEpisodeDetailCoordinator() -> EpisodeDetailCoordinator
}

extension EpisodesExternalDependenciesResolver {
    func resolveEpisodesCoordinator() -> EpisodesCoordinator {
        DefaultEpisodesCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
