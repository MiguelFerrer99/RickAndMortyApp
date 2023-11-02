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
    func resolve(with info: LocationDetailRepresentable) -> LocationDetailViewController
    func resolve(with info: LocationDetailRepresentable) -> LocationDetailViewModel
}

extension LocationDetailDependenciesResolver {
    func resolve(with info: LocationDetailRepresentable) -> LocationDetailViewController {
        LocationDetailViewController(dependencies: self, info: info)
    }
    
    func resolve(with info: LocationDetailRepresentable) -> LocationDetailViewModel {
        LocationDetailViewModel(dependencies: self, info: info)
    }
}
