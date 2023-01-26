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
}

final class DefaultLocationsCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: LocationsExternalDependenciesResolver
    private lazy var dependencies: DefaultLocationsDependenciesResolver = {
        DefaultLocationsDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
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
}

private extension DefaultLocationsCoordinator {
    struct DefaultLocationsDependenciesResolver: LocationsDependenciesResolver {
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
