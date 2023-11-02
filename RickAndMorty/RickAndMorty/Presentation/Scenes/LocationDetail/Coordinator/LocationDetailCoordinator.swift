//
//  LocationDetailCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 29/1/23.
//

import UIKit

protocol LocationDetailCoordinator: Coordinator {
    func setInfo(_ info: LocationDetailRepresentable)
}

final class DefaultLocationDetailCoordinator {
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var info: LocationDetailRepresentable?
    private let externalDependencies: LocationDetailExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: LocationDetailExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultLocationDetailCoordinator: LocationDetailCoordinator {
    func start() {
        guard let info else { return }
        let viewController: LocationDetailViewController = dependencies.resolve(with: info)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setInfo(_ info: LocationDetailRepresentable) {
        self.info = info
    }
}

private extension DefaultLocationDetailCoordinator {
    struct Dependencies: LocationDetailDependenciesResolver {
        let externalDependencies: LocationDetailExternalDependenciesResolver
        unowned let coordinator: LocationDetailCoordinator
        
        var external: LocationDetailExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> LocationDetailCoordinator {
            coordinator
        }
    }
}
