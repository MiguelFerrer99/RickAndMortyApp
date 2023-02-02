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
    var characterNameFiltered: String?
    
    init(dependencies: CharactersDependenciesResolver, representable: CharactersViewModelRepresentable?) {
        self.dependencies = dependencies
        self.representable = representable
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        setCharacters()
    }
    
    func goBack() {
        coordinator.back()
    }
    
    func clearCharactersPager() {
        characterNameFiltered = nil
        charactersPager.reset()
    }
    
    func loadCharaters() {
        loadCharacters(with: characterNameFiltered)
    }
    
    func openCharacter(_ character: CharacterRepresentable) {
        let representable = DefaultCharacterDetailRepresentable(name: character.name,
                                                                image: character.urlImage,
                                                                status: character.status,
                                                                species: character.species,
                                                                gender: character.gender,
                                                                origin: character.origin,
                                                                location: character.location,
                                                                numberOfEpisodes: character.numberOfEpisodes)
        coordinator.openCharacter(with: representable)
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
    
    func loadCharacters(with name: String?) {
        Task {
            let charactersInfo = await charactersUseCase.getCharacters(withName: name, ofPage: charactersPager.currentPage)
            charactersPager.setItems(charactersInfo.results, and: charactersInfo.info.isLast)
            sendStateSubject(.charactersReceived(charactersPager))
        }
    }
}
