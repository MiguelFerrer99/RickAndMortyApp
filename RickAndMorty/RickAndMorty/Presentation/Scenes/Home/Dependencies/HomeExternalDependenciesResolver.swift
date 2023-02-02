//
//  LoadingExternalDependenciesResolver.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol HomeExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveAppDependencies() -> AppDependencies
    func resolveAPIService() -> APIService
    func resolveImageCacheManager() -> ImageCacheManager
    func resolveHomeCoordinator() -> HomeCoordinator
    func resolveAuthorInfoCoordinator() -> AuthorInfoCoordinator
    func resolveCharactersCoordinator() -> CharactersCoordinator
    func resolveCharacterDetailCoordinator() -> CharacterDetailCoordinator
    func resolveLocationsCoordinator() -> LocationsCoordinator
    func resolveLocationDetailCoordinator() -> LocationDetailCoordinator
    func resolveEpisodesCoordinator() -> EpisodesCoordinator
    func resolveEpisodeDetailCoordinator() -> EpisodeDetailCoordinator
}

extension HomeExternalDependenciesResolver {
    func resolveHomeCoordinator() -> HomeCoordinator {
        DefaultHomeCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
