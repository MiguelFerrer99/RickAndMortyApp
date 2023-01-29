//
//  LocationDetailCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import UIKit

protocol LocationDetailCoordinator {
    func start(with representable: LocationDetailRepresentable)
    func back()
}

final class DefaultLocationDetailCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: LocationDetailExternalDependenciesResolver
    private lazy var dependencies: DefaultLocationDetailDependenciesResolver = {
        DefaultLocationDetailDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
    init(externalDependencies: LocationDetailExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultLocationDetailCoordinator: LocationDetailCoordinator {
    func start(with representable: LocationDetailRepresentable) {
        dependencies.representable = representable
        navigationController.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}

private extension DefaultLocationDetailCoordinator {
    struct DefaultLocationDetailDependenciesResolver: LocationDetailDependenciesResolver {
        let externalDependencies: LocationDetailExternalDependenciesResolver
        let coordinator: LocationDetailCoordinator
        var representable: LocationDetailRepresentable?
        
        var external: LocationDetailExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> LocationDetailCoordinator {
            coordinator
        }
        
        func resolve() -> LocationDetailViewModel {
            LocationDetailViewModel(dependencies: self, representable: representable)
        }
    }
}
