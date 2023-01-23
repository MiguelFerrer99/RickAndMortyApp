//
//  LocationsExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol LocationsExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveLocationsCoordinator() -> LocationsCoordinator
}

extension LocationsExternalDependenciesResolver {
    func resolveLocationsCoordinator() -> LocationsCoordinator {
        DefaultLocationsCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
