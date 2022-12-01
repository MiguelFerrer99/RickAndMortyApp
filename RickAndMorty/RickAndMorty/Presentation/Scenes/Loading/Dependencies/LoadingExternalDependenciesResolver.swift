//
//  LoadingExternalDependenciesResolver.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol LoadingExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveHomeCoordinator() -> LoadingCoordinator
}

extension LoadingExternalDependenciesResolver {
    func resolveHomeCoordinator() -> LoadingCoordinator {
        DefaultHomeCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
