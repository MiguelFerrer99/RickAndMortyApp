//
//  LocationsCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol LocationsCoordinator {
    func start(with representable: LocationsViewModelRepresentable)
    func back()
    func openLocationDetail(with representable: LocationDetailRepresentable)
}

final class DefaultLocationsCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: LocationsExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: LocationsExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultLocationsCoordinator: LocationsCoordinator {
    func start(with representable: LocationsViewModelRepresentable) {
        dependencies.representable = representable
        navigationController.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func openLocationDetail(with representable: LocationDetailRepresentable) {
        let coordinator: LocationDetailCoordinator = dependencies.external.resolveLocationDetailCoordinator()
        coordinator.start(with: representable)
    }
}

private extension DefaultLocationsCoordinator {
    struct Dependencies: LocationsDependenciesResolver {
        let externalDependencies: LocationsExternalDependenciesResolver
        let coordinator: LocationsCoordinator
        var representable: LocationsViewModelRepresentable?
        
        var external: LocationsExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> LocationsCoordinator {
            coordinator
        }
        
        func resolve() -> LocationsViewModel {
            LocationsViewModel(dependencies: self, representable: representable)
        }
    }
}
