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
    var state: AnyPublisher<LocationDetailViewModelState, Never> { stateSubject.eraseToAnyPublisher() }
    private let info: LocationDetailRepresentable?
    private lazy var coordinator: LocationDetailCoordinator = dependencies.resolve()
    
    init(dependencies: LocationDetailDependenciesResolver, info: LocationDetailRepresentable) {
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

private extension LocationDetailViewModel {
    func setInfo() {
        guard let info else { return }
        stateSubject.send(.locationReceived(info))
    }
}
