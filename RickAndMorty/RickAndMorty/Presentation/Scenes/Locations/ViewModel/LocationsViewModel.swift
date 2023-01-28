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
    
    func clearFilteredLocationsPager() {
        locationNameFiltered = nil
        locationsPager.reset()
        sendStateSubject(.locationsReceived(locationsPager))
    }
    
    func loadLocations() {
        loadLocations(with: locationNameFiltered)
    }
}

private extension LocationsViewModel {
    var coordinator: LocationsCoordinator {
        dependencies.resolve()
    }
    
    var locationsUseCase: LocationsUseCase {
        dependencies.resolve()
    }
    
    func setLocations() {
        guard let representable = representable else { return }
        locationsPager.setItems(representable.locations, and: representable.isLastPage)
        stateSubject.send(.locationsReceived(locationsPager))
    }
    
    func sendStateSubject(_ stateSubject: LocationsViewModelState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stateSubject.send(stateSubject)
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
