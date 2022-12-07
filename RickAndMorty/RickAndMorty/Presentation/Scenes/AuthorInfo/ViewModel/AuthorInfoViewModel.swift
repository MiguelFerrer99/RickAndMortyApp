//
//  AuthorInfoViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import Combine

enum AuthorInfoViewModelState {
    case idle
}

final class AuthorInfoViewModel {
    private let dependencies: AuthorInfoDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<AuthorInfoViewModelState, Never>(.idle)
    var state: AnyPublisher<AuthorInfoViewModelState, Never>

    init(dependencies: AuthorInfoDependenciesResolver) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func dismiss() {
        coordinator.dismiss()
    }
    
    func openGitHub() {
        coordinator.openGitHub()
    }
    
    func openLinkedIn() {
        coordinator.openLinkedIn()
    }
}

private extension AuthorInfoViewModel {
    var coordinator: AuthorInfoCoordinator {
        dependencies.resolve()
    }
}
