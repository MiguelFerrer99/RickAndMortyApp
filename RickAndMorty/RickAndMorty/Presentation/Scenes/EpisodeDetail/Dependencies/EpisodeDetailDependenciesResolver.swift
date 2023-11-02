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
    func resolve(with info: EpisodeDetailRepresentable) -> EpisodeDetailViewController
    func resolve(with info: EpisodeDetailRepresentable) -> EpisodeDetailViewModel
}

extension EpisodeDetailDependenciesResolver {
    func resolve(with info: EpisodeDetailRepresentable) -> EpisodeDetailViewController {
        EpisodeDetailViewController(dependencies: self, info: info)
    }
    
    func resolve(with info: EpisodeDetailRepresentable) -> EpisodeDetailViewModel {
        EpisodeDetailViewModel(dependencies: self, info: info)
    }
}
