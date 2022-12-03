//
//  HomeCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 3/12/22.
//

import UIKit

protocol HomeCoordinator {
    func start()
}

final class DefaultHomeCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: HomeExternalDependenciesResolver
    private lazy var dependencies: DefaultHomeDependenciesResolver = {
        DefaultHomeDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
    init(externalDependencies: HomeExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultHomeCoordinator: HomeCoordinator {
    func start() {
        guard let window = AppDependencies.shared.window else { return }
        let navigationController = UINavigationController(rootViewController: dependencies.resolve())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

private extension DefaultHomeCoordinator {
    struct DefaultHomeDependenciesResolver: HomeDependenciesResolver {
        let externalDependencies: HomeExternalDependenciesResolver
        let coordinator: HomeCoordinator
        
        var external: HomeExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> HomeCoordinator {
            coordinator
        }
    }
}
