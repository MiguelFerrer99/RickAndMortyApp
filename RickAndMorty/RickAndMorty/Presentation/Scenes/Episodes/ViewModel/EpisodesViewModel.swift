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
    var state: AnyPublisher<EpisodesViewModelState, Never> { stateSubject.eraseToAnyPublisher() }
    private let info: EpisodesViewModelRepresentable?
    private let episodesPager = Pagination<EpisodeRepresentable>()
    private lazy var coordinator: EpisodesCoordinator = dependencies.resolve()
    private lazy var episodesUseCase: EpisodesUseCase = dependencies.resolve()
    var episodeNameFiltered: String?
    
    init(dependencies: EpisodesDependenciesResolver, info: EpisodesViewModelRepresentable) {
        self.dependencies = dependencies
        self.info = info
    }
    
    func viewDidLoad() {
        setEpisodes()
    }
    
    func clearEpisodesPager() {
        episodeNameFiltered = nil
        episodesPager.reset()
    }
    
    func loadEpisodes() {
        loadEpisodes(with: episodeNameFiltered)
    }
    
    func openEpisodeDetail(_ episode: EpisodeRepresentable) {
        let info = DefaultEpisodeDetailRepresentable(name: episode.name,
                                                     airDate: episode.airDate,
                                                     season: episode.season,
                                                     episode: episode.episode,
                                                     numberOfCharacters: episode.numberOfCharacters)
        coordinator.openEpisode(with: info)
        
    }
    
    func dismiss(with type: PopType) {
        coordinator.dismiss(with: type)
    }
}

private extension EpisodesViewModel {
    func setEpisodes() {
        guard let info else { return }
        episodesPager.setItems(info.episodes, and: info.isLastPage)
        stateSubject.send(.episodesReceived(episodesPager))
    }
    
    func loadEpisodes(with name: String?) {
        Task {
            let episodesInfo = await episodesUseCase.getEpisodes(withName: name, ofPage: episodesPager.currentPage)
            episodesPager.setItems(episodesInfo.results, and: episodesInfo.info.isLast)
            sendStateSubject(.episodesReceived(episodesPager))
        }
    }
    
    func sendStateSubject(_ state: EpisodesViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            stateSubject.send(state)
        }
    }
}
