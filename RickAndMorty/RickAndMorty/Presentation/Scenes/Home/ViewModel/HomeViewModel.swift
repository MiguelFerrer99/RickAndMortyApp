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
    case updated(HomeDataCategory)
}

final class HomeViewModel {
    private let dependencies: HomeDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<HomeViewModelState, Never>(.idle)
    var state: AnyPublisher<HomeViewModelState, Never>
    private var categories: [HomeDataCategory] = []
    private let charactersPager = Pagination<CharacterRepresentable>()
    private let locationsPager = Pagination<LocationRepresentable>()
    private let episodesPager = Pagination<EpisodeRepresentable>()

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
        coordinator.openCategoryDetail(category)
    }
    
    func viewMore(of category: HomeDataCategory) {
        switch category {
        case .characters(let pager):
            getCharacters(ofPage: pager.currentPage)
        case .locations(let pager):
            getLocations(ofPage: pager.currentPage)
        case .episodes(let pager):
            getEpisodes(ofPage: pager.currentPage)
        }
    }
}

private extension HomeViewModel {
    var coordinator: HomeCoordinator {
        dependencies.resolve()
    }
    
    var homeUseCase: HomeUseCase {
        dependencies.resolve()
    }
    
    var charactersUseCase: CharactersUseCase {
        dependencies.external.resolveCharactersUseCase()
    }
    
    var locationsUseCase: LocationsUseCase {
        dependencies.external.resolveLocationsUseCase()
    }
    
    var episodesUseCase: EpisodesUseCase {
        dependencies.external.resolveEpisodesUseCase()
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
                charactersPager.setItems(charactersInfo.results, and: charactersInfo.info.isLast)
                categories.append(.characters(charactersPager))
            }
            if let locationsInfo = homeInfo.locationsInfo {
                locationsPager.setItems(locationsInfo.results, and: locationsInfo.info.isLast)
                categories.append(.locations(locationsPager))
            }
            if let episodesInfo = homeInfo.episodesInfo {
                episodesPager.setItems(episodesInfo.results, and: episodesInfo.info.isLast)
                categories.append(.episodes(episodesPager))
            }
            sendStateSubject(.received(categories))
        }
    }
    
    func getCharacters(ofPage page: Int) {
        Task {
            guard let charactersInfo = await charactersUseCase.getInfo(ofPage: page) else { return }
            charactersPager.setItems(charactersInfo.results, and: charactersInfo.info.isLast)
            sendStateSubject(.updated(.characters(charactersPager)))
        }
    }
    
    func getLocations(ofPage page: Int) {
        Task {
            guard let locationsInfo = await locationsUseCase.getInfo(ofPage: page) else { return }
            locationsPager.setItems(locationsInfo.results, and: locationsInfo.info.isLast)
            sendStateSubject(.updated(.locations(locationsPager)))
        }
    }
    
    func getEpisodes(ofPage page: Int) {
        Task {
            guard let episodesInfo = await episodesUseCase.getInfo(ofPage: page) else { return }
            episodesPager.setItems(episodesInfo.results, and: episodesInfo.info.isLast)
            sendStateSubject(.updated(.episodes(episodesPager)))
        }
    }
}
