//
//  LoadingViewModel.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import Combine

enum LoadingViewModelState {
    case idle
    case loading
}

final class LoadingViewModel {
    private let dependencies: LoadingDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<LoadingViewModelState, Never>(.idle)
    var state: AnyPublisher<LoadingViewModelState, Never>

    init(dependencies: LoadingDependenciesResolver) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        stateSubject.send(.loading)
    }
}

private extension LoadingViewModel {
    var coordinator: LoadingCoordinator {
        dependencies.resolve()
    }
}

// MARK: Subscriptions
private extension LoadingViewModel {}

// MARK: Publishers
private extension LoadingViewModel {}
