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
    var state: AnyPublisher<HomeViewModelState, Never> { stateSubject.eraseToAnyPublisher() }
    private var categories: [HomeDataCategory] = []
    private var categoriesLastPages: CategoriesLastPages = (true, true, true)
    private lazy var coordinator: HomeCoordinator = dependencies.resolve()
    private lazy var homeUseCase: HomeUseCase = dependencies.resolve()
    
    init(dependencies: HomeDependenciesResolver) {
        self.dependencies = dependencies
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
    
    func openCharacter(_ character: CharacterRepresentable) {
        let info = DefaultCharacterDetailRepresentable(name: character.name,
                                                       image: character.urlImage,
                                                       status: character.status,
                                                       species: character.species,
                                                       gender: character.gender,
                                                       origin: character.origin,
                                                       location: character.location,
                                                       numberOfEpisodes: character.numberOfEpisodes)
        coordinator.openCharacterDetail(with: info)
    }
    
    func openLocation(_ location: LocationRepresentable) {
        let info = DefaultLocationDetailRepresentable(name: location.name,
                                                      type: location.type,
                                                      dimension: location.dimension,
                                                      numberOfResidents: location.numberOfResidents)
        coordinator.openLocationDetail(with: info)
    }
    
    func openEpisode(_ episode: EpisodeRepresentable) {
        let info = DefaultEpisodeDetailRepresentable(name: episode.name,
                                                     airDate: episode.airDate,
                                                     season: episode.season,
                                                     episode: episode.episode,
                                                     numberOfCharacters: episode.numberOfCharacters)
        coordinator.openEpisodeDetail(with: info)
    }
}

private extension HomeViewModel {
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
    
    func sendStateSubject(_ state: HomeViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            stateSubject.send(state)
        }
    }
}
