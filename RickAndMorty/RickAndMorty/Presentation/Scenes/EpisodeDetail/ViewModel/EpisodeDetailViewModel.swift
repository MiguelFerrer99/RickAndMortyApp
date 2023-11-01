//
//  EpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import Combine

enum EpisodeDetailViewModelState {
    case idle
    case episodeReceived(EpisodeDetailRepresentable)
}

final class EpisodeDetailViewModel {
    private let dependencies: EpisodeDetailDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<EpisodeDetailViewModelState, Never>(.idle)
    var state: AnyPublisher<EpisodeDetailViewModelState, Never>
    private let representable: EpisodeDetailRepresentable?
    private lazy var coordinator: EpisodeDetailCoordinator = dependencies.resolve()

    init(dependencies: EpisodeDetailDependenciesResolver, representable: EpisodeDetailRepresentable?) {
        self.dependencies = dependencies
        self.representable = representable
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        setInfo()
    }
    
    func goBack() {
        coordinator.back()
    }
}

private extension EpisodeDetailViewModel {
    func setInfo() {
        guard let representable else { return }
        stateSubject.send(.episodeReceived(representable))
    }
}
