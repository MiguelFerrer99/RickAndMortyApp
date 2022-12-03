//
//  LoadingCoordinator.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol LoadingCoordinator {
    func start()
    func openHome()
}

final class DefaultLoadingCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: LoadingExternalDependenciesResolver
    private lazy var dependencies: DefaultLoadingDependenciesResolver = {
        DefaultLoadingDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
    init(externalDependencies: LoadingExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultLoadingCoordinator: LoadingCoordinator {
    func start() {
        guard let window = AppDependencies.shared.window else { return }
        navigationController.setViewControllers([dependencies.resolve()], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func openHome() {
        let coordinator = dependencies.external.resolveHomeCoordinator()
        coordinator.start()
    }
}

private extension DefaultLoadingCoordinator {
    struct DefaultLoadingDependenciesResolver: LoadingDependenciesResolver {
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
