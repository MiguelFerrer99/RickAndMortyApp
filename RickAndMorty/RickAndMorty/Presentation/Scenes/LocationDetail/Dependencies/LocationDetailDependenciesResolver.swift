//
//  LocationDetailDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import UIKit

protocol LocationDetailDependenciesResolver {
    var external: LocationDetailExternalDependenciesResolver { get }
    func resolve() -> LocationDetailCoordinator
    func resolve() -> LocationDetailViewController
    func resolve() -> LocationDetailViewModel
}

extension LocationDetailDependenciesResolver {
    func resolve() -> LocationDetailViewController {
        LocationDetailViewController(dependencies: self)
    }
}
