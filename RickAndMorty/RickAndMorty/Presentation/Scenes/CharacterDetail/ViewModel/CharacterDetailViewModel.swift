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
    var state: AnyPublisher<CharacterDetailViewModelState, Never> { stateSubject.eraseToAnyPublisher() }
    private let info: CharacterDetailRepresentable?
    private lazy var coordinator: CharacterDetailCoordinator = dependencies.resolve()
    
    init(dependencies: CharacterDetailDependenciesResolver, info: CharacterDetailRepresentable) {
        self.dependencies = dependencies
        self.info = info
    }
    
    func viewDidLoad() {
        setInfo()
    }
    
    func dismiss(with type: PopType) {
        coordinator.dismiss(with: type)
    }
}

private extension CharacterDetailViewModel {
    func setInfo() {
        guard let info else { return }
        stateSubject.send(.characterReceived(info))
    }
}
