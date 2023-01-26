//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 22/1/23.
//

import Foundation
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
        setCharacters()
    }
    
    func viewMoreCharacters() {
        loadMoreCharacters()
    }
}

private extension CharactersViewModel {
    var coordinator: CharactersCoordinator {
        dependencies.resolve()
    }
    
    var charactersUseCase: CharactersUseCase {
        dependencies.resolve()
    }
    
    func setCharacters() {
        guard let representable = representable else { return }
        charactersPager.setItems(representable.characters, and: representable.isLastPage)
        stateSubject.send(.charactersReceived(charactersPager))
    }
    
    func sendStateSubject(_ stateSubject: CharactersViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stateSubject.send(stateSubject)
        }
    }
    
    func loadMoreCharacters() {
        Task {
            let charactersInfo = await charactersUseCase.getCharacters(ofPage: charactersPager.currentPage)
            if let charactersInfo = charactersInfo {
                charactersPager.setItems(charactersInfo.results, and: charactersInfo.info.isLast)
                sendStateSubject(.charactersReceived(charactersPager))
            }
        }
    }
}
