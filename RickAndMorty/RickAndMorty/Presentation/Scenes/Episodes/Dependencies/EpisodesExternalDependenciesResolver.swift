//
//  EpisodesExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol EpisodesExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveEpisodesCoordinator() -> EpisodesCoordinator
}

extension EpisodesExternalDependenciesResolver {
    func resolveEpisodesCoordinator() -> EpisodesCoordinator {
        DefaultEpisodesCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
