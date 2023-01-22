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
                categories.append(.characters(charactersInfo.results))
            }
            if let locationsInfo = homeInfo.locationsInfo {
                categories.append(.locations(locationsInfo.results))
            }
            if let episodesInfo = homeInfo.episodesInfo {
                categories.append(.episodes(episodesInfo.results))
            }
            sendStateSubject(.received(categories))
        }
    }
}
