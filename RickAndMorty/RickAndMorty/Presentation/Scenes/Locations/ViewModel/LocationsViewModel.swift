//
//  LocationsViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import Combine

enum LocationsViewModelState {
    case idle
}

final class LocationsViewModel {
    private let dependencies: LocationsDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<LocationsViewModelState, Never>(.idle)
    var state: AnyPublisher<LocationsViewModelState, Never>
    private let representable: LocationsViewModelRepresentable?

    init(dependencies: LocationsDependenciesResolver, representable: LocationsViewModelRepresentable?) {
        self.dependencies = dependencies
        self.representable = representable
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        // Execute UseCases
    }
}

private extension LocationsViewModel {
    var coordinator: LocationsCoordinator {
        dependencies.resolve()
    }
}
