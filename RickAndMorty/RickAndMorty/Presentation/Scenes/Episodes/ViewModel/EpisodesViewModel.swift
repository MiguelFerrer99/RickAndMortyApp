//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import Combine

enum EpisodesViewModelState {
    case idle
}

final class EpisodesViewModel {
    private let dependencies: EpisodesDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<EpisodesViewModelState, Never>(.idle)
    var state: AnyPublisher<EpisodesViewModelState, Never>
    private let episodes: [EpisodeRepresentable]

    init(dependencies: EpisodesDependenciesResolver, episodes: [EpisodeRepresentable]) {
        self.dependencies = dependencies
        self.episodes = episodes
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        // Execute UseCases
    }
}

private extension EpisodesViewModel {
    var coordinator: EpisodesCoordinator {
        dependencies.resolve()
    }
}
