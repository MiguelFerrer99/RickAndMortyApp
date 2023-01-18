//
//  LoadingExternalDependenciesResolver.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol HomeExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveAppDependencies() -> AppDependencies
    func resolveHomeCoordinator() -> HomeCoordinator
    func resolve() -> HomeRepository
    func resolveAuthorInfoCoordinator() -> AuthorInfoCoordinator
}

extension HomeExternalDependenciesResolver {
    func resolveHomeCoordinator() -> HomeCoordinator {
        DefaultHomeCoordinator(externalDependencies: self, navigationController: resolve())
    }
    
    func resolve() -> HomeRepository {
        DefaultHomeRepository(dependencies: self)
    }
    
    func resolveCharactersUseCase() -> CharactersUseCase {
        DefaultCharactersUseCase(repository: resolve())
    }
    
    func resolveLocationsUseCase() -> LocationsUseCase {
        DefaultLocationsUseCase(repository: resolve())
    }
    
    func resolveEpisodesUseCase() -> EpisodesUseCase {
        DefaultEpisodesUseCase(repository: resolve())
    }
}
