//
//  LocationDetailViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import Combine

enum LocationDetailViewModelState {
    case idle
    case locationReceived(LocationDetailRepresentable)
}

final class LocationDetailViewModel {
    private let dependencies: LocationDetailDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<LocationDetailViewModelState, Never>(.idle)
    var state: AnyPublisher<LocationDetailViewModelState, Never>
    private let representable: LocationDetailRepresentable?

    init(dependencies: LocationDetailDependenciesResolver, representable: LocationDetailRepresentable?) {
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

private extension LocationDetailViewModel {
    var coordinator: LocationDetailCoordinator {
        dependencies.resolve()
    }
    
    func setInfo() {
        guard let representable = representable else { return }
        stateSubject.send(.locationReceived(representable))
    }
}
