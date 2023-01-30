//
//  LoadingViewModel.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import Foundation
import Combine

enum HomeViewModelState {
    case idle
    case loading
    case error
    case received([HomeDataCategory])
}

final class HomeViewModel {
    private let dependencies: HomeDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<HomeViewModelState, Never>(.idle)
    var state: AnyPublisher<HomeViewModelState, Never>
    private var categories: [HomeDataCategory] = []
    private var categoriesLastPages: CategoriesLastPages = (true, true, true)

    init(dependencies: HomeDependenciesResolver) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        stateSubject.send(.loading)
        getInfo()
    }
    
    func openAuthorInfo() {
        coordinator.openAuthorInfo()
    }
    
    func openCategoryDetail(_ category: HomeDataCategory) {
        switch category {
        case .characters(let info):
            let representable = DefaultCharactersViewModelRepresentable(characters: info, isLastPage: categoriesLastPages.isLastPageCharacters)
            coordinator.openCharacters(with: representable)
        case .locations(let info):
            let representable = DefaultLocationsViewModelRepresentable(locations: info, isLastPage: categoriesLastPages.isLastPageLocations)
            coordinator.openLocations(with: representable)
        case .episodes(let info):
            let representable = DefaultEpisodesViewModelRepresentable(episodes: info, isLastPage: categoriesLastPages.isLastPageEpisodes)
            coordinator.openEpisodes(with: representable)
        }
    }
    
    func openLocation(_ location: LocationRepresentable) {
        let representable = DefaultLocationDetailRepresentable(name: location.name,
                                                               type: location.type,
                                                               dimension: location.dimension,
                                                               numberOfResidents: location.numberOfResidents)
        coordinator.openLocationDetail(with: representable)
    }
    
    func openEpisode(_ episode: EpisodeRepresentable) {
        let representable = DefaultEpisodeDetailRepresentable(name: episode.name,
                                                              airDate: episode.airDate,
                                                              season: episode.season,
                                                              episode: episode.episode,
                                                              numberOfCharacters: episode.numberOfCharacters)
        coordinator.openEpisodeDetail(with: representable)
    }
}

private extension HomeViewModel {
    var coordinator: HomeCoordinator {
        dependencies.resolve()
    }
    
    var homeUseCase: HomeUseCase {
        dependencies.resolve()
    }
    
    func sendStateSubject(_ stateSubject: HomeViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stateSubject.send(stateSubject)
        }
    }
    
    func getInfo() {
        Task {
            let homeInfo = await homeUseCase.getInfo()
            if let charactersInfo = homeInfo.charactersInfo {
                categoriesLastPages.isLastPageCharacters = charactersInfo.info.isLast
                categories.append(.characters(charactersInfo.results))
            }
            if let locationsInfo = homeInfo.locationsInfo {
                categoriesLastPages.isLastPageLocations = locationsInfo.info.isLast
                categories.append(.locations(locationsInfo.results))
            }
            if let episodesInfo = homeInfo.episodesInfo {
                categoriesLastPages.isLastPageEpisodes = episodesInfo.info.isLast
                categories.append(.episodes(episodesInfo.results))
            }
            sendStateSubject(categories.isNotEmpty ? .received(categories) : .error)
        }
    }
}
