//
//  LocationsExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol LocationsExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> LocationsCoordinator
    func resolve() -> LocationDetailCoordinator
}

extension LocationsExternalDependenciesResolver {
    func resolve() -> LocationsCoordinator {
        DefaultLocationsCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
