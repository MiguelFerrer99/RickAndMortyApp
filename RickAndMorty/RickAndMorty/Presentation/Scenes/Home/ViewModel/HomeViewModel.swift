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
        getCharacters()
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
    
    func sendStateSubject(_ stateSubject: HomeViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stateSubject.send(.received(self.categories))
        }
    }
    
    func getCharacters() {
        Task {
            guard let charactersInfo = try? await self.homeUseCase.getCharacters() else { return }
            categories.append(.characters(info: charactersInfo))
            sendStateSubject(.received(categories))
        }
    }
}
