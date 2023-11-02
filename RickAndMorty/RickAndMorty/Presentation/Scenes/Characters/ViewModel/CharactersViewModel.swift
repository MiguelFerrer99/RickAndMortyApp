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
    var state: AnyPublisher<CharactersViewModelState, Never> { stateSubject.eraseToAnyPublisher() }
    private let info: CharactersViewModelRepresentable?
    private let charactersPager = Pagination<CharacterRepresentable>()
    private lazy var coordinator: CharactersCoordinator = dependencies.resolve()
    private lazy var charactersUseCase: CharactersUseCase = dependencies.resolve()
    var characterNameFiltered: String?
    
    init(dependencies: CharactersDependenciesResolver, info: CharactersViewModelRepresentable) {
        self.dependencies = dependencies
        self.info = info
    }
    
    func viewDidLoad() {
        setCharacters()
    }
    
    func clearCharactersPager() {
        characterNameFiltered = nil
        charactersPager.reset()
    }
    
    func loadCharaters() {
        loadCharacters(with: characterNameFiltered)
    }
    
    func openCharacter(_ character: CharacterRepresentable) {
        let info = DefaultCharacterDetailRepresentable(name: character.name,
                                                       image: character.urlImage,
                                                       status: character.status,
                                                       species: character.species,
                                                       gender: character.gender,
                                                       origin: character.origin,
                                                       location: character.location,
                                                       numberOfEpisodes: character.numberOfEpisodes)
        coordinator.openCharacter(with: info)
    }
    
    func dismiss(with type: PopType) {
        coordinator.dismiss(with: type)
    }
}

private extension CharactersViewModel {
    func setCharacters() {
        guard let info else { return }
        charactersPager.setItems(info.characters, and: info.isLastPage)
        stateSubject.send(.charactersReceived(charactersPager))
    }
    
    func loadCharacters(with name: String?) {
        Task {
            let charactersInfo = await charactersUseCase.getCharacters(withName: name, ofPage: charactersPager.currentPage)
            charactersPager.setItems(charactersInfo.results, and: charactersInfo.info.isLast)
            sendStateSubject(.charactersReceived(charactersPager))
        }
    }
    
    func sendStateSubject(_ state: CharactersViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            stateSubject.send(state)
        }
    }
}
