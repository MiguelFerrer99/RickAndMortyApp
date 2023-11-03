//
//  LocationsCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 23/1/23.
//

import UIKit

protocol LocationsCoordinator: Coordinator {
    func setInfo(_ info: LocationsViewModelRepresentable)
    func openLocationDetail(with info: LocationDetailRepresentable)
}

final class DefaultLocationsCoordinator {
    var navigationController: UINavigationController
    private var info: LocationsViewModelRepresentable?
    private let externalDependencies: LocationsExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: LocationsExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultLocationsCoordinator: LocationsCoordinator {
    func start() {
        guard let info else { return }
        let viewController: LocationsViewController = dependencies.resolve(with: info)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setInfo(_ info: LocationsViewModelRepresentable) {
        self.info = info
    }
    
    func openLocationDetail(with info: LocationDetailRepresentable) {
        let coordinator: LocationDetailCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
    }
}

private extension DefaultLocationsCoordinator {
    struct Dependencies: LocationsDependenciesResolver {
        let externalDependencies: LocationsExternalDependenciesResolver
        let coordinator: LocationsCoordinator
        
        var external: LocationsExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> LocationsCoordinator {
            coordinator
        }
    }
}
