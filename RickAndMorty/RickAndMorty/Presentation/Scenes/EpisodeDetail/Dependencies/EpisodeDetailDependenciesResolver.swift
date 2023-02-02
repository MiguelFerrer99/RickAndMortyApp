//
//  EpisodeDetailDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import UIKit

protocol EpisodeDetailDependenciesResolver {
    var external: EpisodeDetailExternalDependenciesResolver { get }
    func resolve() -> EpisodeDetailCoordinator
    func resolve() -> EpisodeDetailViewController
    func resolve() -> EpisodeDetailViewModel
}

extension EpisodeDetailDependenciesResolver {
    func resolve() -> EpisodeDetailViewController {
        EpisodeDetailViewController(dependencies: self)
    }
}
