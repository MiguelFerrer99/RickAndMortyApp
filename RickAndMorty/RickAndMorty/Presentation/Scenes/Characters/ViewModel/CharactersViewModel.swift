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
    private let characters: [CharacterRepresentable]

    init(dependencies: CharactersDependenciesResolver, characters: [CharacterRepresentable]) {
        self.dependencies = dependencies
        self.characters = characters
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        // Execute UseCases
    }
}

private extension CharactersViewModel {
    var coordinator: CharactersCoordinator {
        dependencies.resolve()
    }
}
