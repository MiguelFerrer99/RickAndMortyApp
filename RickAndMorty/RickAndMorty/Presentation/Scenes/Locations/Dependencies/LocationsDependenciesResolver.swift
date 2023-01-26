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
    func resolve() -> LocationsViewController
    func resolve() -> LocationsViewModel
    func resolve() -> LocationsUseCase
    func resolve() -> LocationRepository
}

extension LocationsDependenciesResolver {
    func resolve() -> LocationsViewController {
        LocationsViewController(dependencies: self)
    }
    
    func resolve() -> LocationsUseCase {
        DefaultLocationsUseCase(dependencies: self)
    }
    
    func resolve() -> LocationRepository {
        DefaultLocationRepository(dependencies: self)
    }
}
