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
    
    private let categories: [HomeDataCategory] = [.characters, .locations, .episodes]

    init(dependencies: HomeDependenciesResolver) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        getInfo()
    }
    
    func tryAgain() {
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
    
    func getInfo() {
        stateSubject.send(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.stateSubject.send(.received(self.categories))
        }
    }
}

// MARK: Subscriptions
private extension HomeViewModel {}

// MARK: Publishers
private extension HomeViewModel {}
