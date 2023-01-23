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
}

extension LocationsDependenciesResolver {
    func resolve() -> LocationsViewController {
        LocationsViewController(dependencies: self)
    }
    
    func resolve() -> LocationsViewModel {
        LocationsViewModel(dependencies: self)
    }
}
