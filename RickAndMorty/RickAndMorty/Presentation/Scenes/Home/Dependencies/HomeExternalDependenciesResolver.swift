//
//  LoadingExternalDependenciesResolver.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol HomeExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveAppDependencies() -> AppDependencies
    func resolveHomeCoordinator() -> HomeCoordinator
    func resolveAuthorInfoCoordinator() -> AuthorInfoCoordinator
    func resolveHomeRepository() -> HomeRepository
    func resolveAPIService() -> APIService
}

extension HomeExternalDependenciesResolver {
    func resolveHomeCoordinator() -> HomeCoordinator {
        DefaultHomeCoordinator(externalDependencies: self, navigationController: resolve())
    }
    
    func resolveHomeRepository() -> HomeRepository {
        DefaultHomeRepository(dependencies: self)
    }
}
