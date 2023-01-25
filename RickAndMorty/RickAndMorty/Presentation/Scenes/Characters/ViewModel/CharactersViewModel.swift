//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import Combine

enum CharactersViewModelState {
    case idle
    case charactersReceived(Pagination<CharacterRepresentable>)
}

final class CharactersViewModel {
    private let dependencies: CharactersDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<CharactersViewModelState, Never>(.idle)
    var state: AnyPublisher<CharactersViewModelState, Never>
    private let representable: CharactersViewModelRepresentable?
    private let charactersPager = Pagination<CharacterRepresentable>()

    init(dependencies: CharactersDependenciesResolver, representable: CharactersViewModelRepresentable?) {
        self.dependencies = dependencies
        self.representable = representable
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        guard let representable = representable else { return }
        charactersPager.setItems(representable.characters, and: representable.isLastPage)
        stateSubject.send(.charactersReceived(charactersPager))
    }
}

private extension CharactersViewModel {
    var coordinator: CharactersCoordinator {
        dependencies.resolve()
    }
}
