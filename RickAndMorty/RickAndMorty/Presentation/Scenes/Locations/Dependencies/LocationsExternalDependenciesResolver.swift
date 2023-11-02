//
//  LocationsExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol LocationsExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolveLocationsCoordinator() -> LocationsCoordinator
    func resolveLocationDetailCoordinator() -> LocationDetailCoordinator
}

extension LocationsExternalDependenciesResolver {
    func resolveLocationsCoordinator() -> LocationsCoordinator {
        DefaultLocationsCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
