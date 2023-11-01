//
//  LocationsViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import Foundation
import Combine

enum LocationsViewModelState {
    case idle
    case locationsReceived(Pagination<LocationRepresentable>)
}

final class LocationsViewModel {
    private let dependencies: LocationsDependenciesResolver
    private var subscriptions: Set<AnyCancellable> = []
    private let stateSubject = CurrentValueSubject<LocationsViewModelState, Never>(.idle)
    var state: AnyPublisher<LocationsViewModelState, Never>
    private let representable: LocationsViewModelRepresentable?
    private let locationsPager = Pagination<LocationRepresentable>()
    private lazy var coordinator: LocationsCoordinator = dependencies.resolve()
    private lazy var locationsUseCase: LocationsUseCase = dependencies.resolve()
    var locationNameFiltered: String?

    init(dependencies: LocationsDependenciesResolver, representable: LocationsViewModelRepresentable?) {
        self.dependencies = dependencies
        self.representable = representable
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        setLocations()
    }
    
    func goBack() {
        coordinator.back()
    }
    
    func clearLocationsPager() {
        locationNameFiltered = nil
        locationsPager.reset()
    }
    
    func loadLocations() {
        loadLocations(with: locationNameFiltered)
    }
    
    func openLocationDetail(_ location: LocationRepresentable) {
        let representable = DefaultLocationDetailRepresentable(name: location.name,
                                                               type: location.type,
                                                               dimension: location.dimension,
                                                               numberOfResidents: location.numberOfResidents)
        coordinator.openLocationDetail(with: representable)
    }
}

private extension LocationsViewModel {
    func setLocations() {
        guard let representable else { return }
        locationsPager.setItems(representable.locations, and: representable.isLastPage)
        stateSubject.send(.locationsReceived(locationsPager))
    }
    
    func sendStateSubject(_ state: LocationsViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            stateSubject.send(state)
        }
    }
    
    func loadLocations(with name: String?) {
        Task {
            let locationsInfo = await locationsUseCase.getLocations(withName: name, ofPage: locationsPager.currentPage)
            locationsPager.setItems(locationsInfo.results, and: locationsInfo.info.isLast)
            sendStateSubject(.locationsReceived(locationsPager))
        }
    }
}
