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

    init(dependencies: EpisodesDependenciesResolver) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        // Subscribe events and execute UseCases
    }
}

private extension EpisodesViewModel {
    var coordinator: EpisodesCoordinator {
        dependencies.resolve()
    }
}

// MARK: Subscriptions
private extension EpisodesViewModel {}

// MARK: Publishers
private extension EpisodesViewModel {}
