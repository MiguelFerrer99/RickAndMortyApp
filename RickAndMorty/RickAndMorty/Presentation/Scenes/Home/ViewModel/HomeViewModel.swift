//
//  HomeViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 3/12/22.
//

import Combine

enum HomeViewModelState {
    case idle
}

final class HomeViewModel {
    private let dependencies: HomeDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<HomeViewModelState, Never>(.idle)
    var state: AnyPublisher<HomeViewModelState, Never>

    init(dependencies: HomeDependenciesResolver) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        // Subscribe events and execute UseCases
    }
    
    func openAuthorBottomSheet() {
        print("Did tap Title View")
    }
}

private extension HomeViewModel {
    var coordinator: HomeCoordinator {
        dependencies.resolve()
    }
}

// MARK: Subscriptions
private extension HomeViewModel {}

// MARK: Publishers
private extension HomeViewModel {}
