//
//  LocationDetailExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import UIKit

protocol LocationDetailExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveLocationDetailCoordinator() -> LocationDetailCoordinator
}

extension LocationDetailExternalDependenciesResolver {
    func resolveLocationDetailCoordinator() -> LocationDetailCoordinator {
        DefaultLocationDetailCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
