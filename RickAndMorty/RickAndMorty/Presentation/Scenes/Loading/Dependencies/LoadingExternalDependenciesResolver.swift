//
//  LoadingExternalDependenciesResolver.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol LoadingExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveLoadingCoordinator() -> LoadingCoordinator
    func resolveHomeCoordinator() -> HomeCoordinator
}

extension LoadingExternalDependenciesResolver {
    func resolveLoadingCoordinator() -> LoadingCoordinator {
        DefaultLoadingCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
