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
    private let representable: EpisodesViewModelRepresentable?

    init(dependencies: EpisodesDependenciesResolver, representable: EpisodesViewModelRepresentable?) {
        self.dependencies = dependencies
        self.representable = representable
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
