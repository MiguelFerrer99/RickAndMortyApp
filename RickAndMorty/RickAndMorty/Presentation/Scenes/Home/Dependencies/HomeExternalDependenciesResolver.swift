//
//  LoadingExternalDependenciesResolver.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol HomeExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> AppDependencies
    func resolve() -> HomeCoordinator
    func resolve() -> AuthorInfoCoordinator
    func resolve() -> CharactersCoordinator
    func resolve() -> CharacterDetailCoordinator
    func resolve() -> LocationsCoordinator
    func resolve() -> LocationDetailCoordinator
    func resolve() -> EpisodesCoordinator
    func resolve() -> EpisodeDetailCoordinator
}

extension HomeExternalDependenciesResolver {
    func resolve() -> HomeCoordinator {
        DefaultHomeCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
