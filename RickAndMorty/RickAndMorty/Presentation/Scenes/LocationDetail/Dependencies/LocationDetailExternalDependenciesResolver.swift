//
//  LocationDetailExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import UIKit

protocol LocationDetailExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> LocationDetailCoordinator
}

extension LocationDetailExternalDependenciesResolver {
    func resolve() -> LocationDetailCoordinator {
        DefaultLocationDetailCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
