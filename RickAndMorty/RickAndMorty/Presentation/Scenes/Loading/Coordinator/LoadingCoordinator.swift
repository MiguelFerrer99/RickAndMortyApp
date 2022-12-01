//
//  LoadingCoordinator.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol LoadingCoordinator {
    func setAsRoot(with window: UIWindow)
}

final class DefaultHomeCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: LoadingExternalDependenciesResolver
    private lazy var dependencies: DefaultHomeDependenciesResolver = {
        DefaultHomeDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
    init(externalDependencies: LoadingExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultHomeCoordinator: LoadingCoordinator {
    func setAsRoot(with window: UIWindow) {
        navigationController.setViewControllers([dependencies.resolve()], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

private extension DefaultHomeCoordinator {
    struct DefaultHomeDependenciesResolver: LoadingDependenciesResolver {
        let externalDependencies: LoadingExternalDependenciesResolver
        let coordinator: LoadingCoordinator
        
        var external: LoadingExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> LoadingCoordinator {
            coordinator
        }
    }
}
