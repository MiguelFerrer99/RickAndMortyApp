//
//  LocationsDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol LocationsDependenciesResolver {
    var external: LocationsExternalDependenciesResolver { get }
    func resolve() -> LocationsCoordinator
    func resolve(with info: LocationsViewModelRepresentable) -> LocationsViewController
    func resolve(with info: LocationsViewModelRepresentable) -> LocationsViewModel
    func resolve() -> LocationsUseCase
    func resolve() -> LocationRepository
}

extension LocationsDependenciesResolver {
    func resolve(with info: LocationsViewModelRepresentable) -> LocationsViewController {
        LocationsViewController(dependencies: self, info: info)
    }
    
    func resolve(with info: LocationsViewModelRepresentable) -> LocationsViewModel {
        LocationsViewModel(dependencies: self, info: info)
    }
    
    func resolve() -> LocationsUseCase {
        DefaultLocationsUseCase(dependencies: self)
    }
    
    func resolve() -> LocationRepository {
        DefaultLocationRepository(dependencies: self)
    }
}
