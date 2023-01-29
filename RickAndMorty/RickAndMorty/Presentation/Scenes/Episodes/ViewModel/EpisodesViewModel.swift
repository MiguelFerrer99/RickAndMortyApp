//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import Foundation
import Combine

enum EpisodesViewModelState {
    case idle
    case episodesReceived(Pagination<EpisodeRepresentable>)
}

final class EpisodesViewModel {
    private let dependencies: EpisodesDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<EpisodesViewModelState, Never>(.idle)
    var state: AnyPublisher<EpisodesViewModelState, Never>
    private let representable: EpisodesViewModelRepresentable?
    private let episodesPager = Pagination<EpisodeRepresentable>()
    var episodeNameFiltered: String?

    init(dependencies: EpisodesDependenciesResolver, representable: EpisodesViewModelRepresentable?) {
        self.dependencies = dependencies
        self.representable = representable
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        setEpisodes()
    }
    
    func goBack() {
        coordinator.back()
    }
    
    func clearEpisodesPager() {
        episodeNameFiltered = nil
        episodesPager.reset()
    }
    
    func loadEpisodes() {
        loadEpisodes(with: episodeNameFiltered)
    }
}

private extension EpisodesViewModel {
    var coordinator: EpisodesCoordinator {
        dependencies.resolve()
    }
    
    
    var episodesUseCase: EpisodesUseCase {
        dependencies.resolve()
    }
    
    func setEpisodes() {
        guard let representable = representable else { return }
        episodesPager.setItems(representable.episodes, and: representable.isLastPage)
        stateSubject.send(.episodesReceived(episodesPager))
    }
    
    func sendStateSubject(_ stateSubject: EpisodesViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stateSubject.send(stateSubject)
        }
    }
    
    func loadEpisodes(with name: String?) {
        Task {
            let episodesInfo = await episodesUseCase.getEpisodes(withName: name, ofPage: episodesPager.currentPage)
            episodesPager.setItems(episodesInfo.results, and: episodesInfo.info.isLast)
            sendStateSubject(.episodesReceived(episodesPager))
        }
    }
}
