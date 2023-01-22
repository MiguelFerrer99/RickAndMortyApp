//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import Combine

enum CharactersViewModelState {
    case idle
}

final class CharactersViewModel {
    private let dependencies: CharactersDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<CharactersViewModelState, Never>(.idle)
    var state: AnyPublisher<CharactersViewModelState, Never>

    init(dependencies: CharactersDependenciesResolver) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        // Subscribe events and execute UseCases
    }
}

private extension CharactersViewModel {
    var coordinator: CharactersCoordinator {
        dependencies.resolve()
    }
}

// MARK: Subscriptions
private extension CharactersViewModel {}

// MARK: Publishers
private extension CharactersViewModel {}
