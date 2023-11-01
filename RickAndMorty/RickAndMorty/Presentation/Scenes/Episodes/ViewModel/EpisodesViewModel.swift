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
    private lazy var coordinator: EpisodesCoordinator = dependencies.resolve()
    private lazy var episodesUseCase: EpisodesUseCase = dependencies.resolve()
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
    
    func openEpisodeDetail(_ episode: EpisodeRepresentable) {
        let representable = DefaultEpisodeDetailRepresentable(name: episode.name,
                                                              airDate: episode.airDate,
                                                              season: episode.season,
                                                              episode: episode.episode,
                                                              numberOfCharacters: episode.numberOfCharacters)
        coordinator.openEpisode(representable)
        
    }
}

private extension EpisodesViewModel {
    func setEpisodes() {
        guard let representable else { return }
        episodesPager.setItems(representable.episodes, and: representable.isLastPage)
        stateSubject.send(.episodesReceived(episodesPager))
    }
    
    func sendStateSubject(_ state: EpisodesViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            stateSubject.send(state)
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
