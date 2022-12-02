//
//  LoadingViewModel.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import Foundation
import Combine

enum LoadingViewModelState {
    case idle
    case loading
    case error
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
        getInfo()
    }
    
    func getInfoAgain() {
        getInfo()
    }
}

private extension LoadingViewModel {
    var coordinator: LoadingCoordinator {
        dependencies.resolve()
    }
    
    func getInfo() {
        stateSubject.send(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.stateSubject.send(.error)
        }
    }
}

// MARK: Subscriptions
private extension LoadingViewModel {}

// MARK: Publishers
private extension LoadingViewModel {}
