//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import Combine

enum CharacterDetailViewModelState {
    case idle
    case characterReceived(CharacterDetailRepresentable)
}

final class CharacterDetailViewModel {
    private let dependencies: CharacterDetailDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<CharacterDetailViewModelState, Never>(.idle)
    var state: AnyPublisher<CharacterDetailViewModelState, Never>
    private let representable: CharacterDetailRepresentable?

    init(dependencies: CharacterDetailDependenciesResolver, representable: CharacterDetailRepresentable?) {
        self.dependencies = dependencies
        self.representable = representable
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        setInfo()
    }
    
    func goBack() {
        coordinator.back()
    }
}

private extension CharacterDetailViewModel {
    var coordinator: CharacterDetailCoordinator {
        dependencies.resolve()
    }
    
    func setInfo() {
        guard let representable = representable else { return }
        stateSubject.send(.characterReceived(representable))
    }
}
