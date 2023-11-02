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
    var state: AnyPublisher<EpisodeDetailViewModelState, Never> { stateSubject.eraseToAnyPublisher() }
    private let info: EpisodeDetailRepresentable?
    private lazy var coordinator: EpisodeDetailCoordinator = dependencies.resolve()
    
    init(dependencies: EpisodeDetailDependenciesResolver, info: EpisodeDetailRepresentable?) {
        self.dependencies = dependencies
        self.info = info
    }
    
    func viewDidLoad() {
        setInfo()
    }
    
    func dismiss(with type: PopType) {
        coordinator.dismiss(with: type)
    }
}

private extension EpisodeDetailViewModel {
    func setInfo() {
        guard let info else { return }
        stateSubject.send(.episodeReceived(info))
    }
}
