//
//  LoadingDependenciesResolver.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

protocol LoadingDependenciesResolver {
    var external: LoadingExternalDependenciesResolver { get }
    func resolve() -> LoadingCoordinator
    func resolve() -> LoadingViewController
    func resolve() -> LoadingViewModel
    func resolve() -> HomeRepository
    func resolve() -> HomeUseCase
}

extension LoadingDependenciesResolver {
    func resolve() -> LoadingViewController {
        LoadingViewController(dependencies: self)
    }
    
    func resolve() -> LoadingViewModel {
        LoadingViewModel(dependencies: self)
    }
    
    func resolve() -> HomeRepository {
        DefaultHomeRepository(dependencies: self)
    }
    
    func resolve() -> HomeUseCase {
        DefaultHomeUseCase(dependencies: self)
    }
}
