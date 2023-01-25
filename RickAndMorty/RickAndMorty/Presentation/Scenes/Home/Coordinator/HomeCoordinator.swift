//
//  HomeCoordinator.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol HomeCoordinator {
    func start()
    func openAuthorInfo()
    func openCategoryDetail(_ category: HomeDataCategory)
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
        guard let window = dependencies.external.resolveAppDependencies().getWindow() else { return }
        navigationController.setViewControllers([dependencies.resolve()], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func openAuthorInfo() {
        let coordinator = dependencies.external.resolveAuthorInfoCoordinator()
        coordinator.start()
    }
    
    func openCategoryDetail(_ category: HomeDataCategory) {
        switch category {
        case .characters(let info):
            let coordinator: CharactersCoordinator = dependencies.external.resolveCharactersCoordinator()
            coordinator.start(with: info)
        case .locations(let info):
            let coordinator: LocationsCoordinator = dependencies.external.resolveLocationsCoordinator()
            coordinator.start(with: info)
        case .episodes(let info):
            let coordinator: EpisodesCoordinator = dependencies.external.resolveEpisodesCoordinator()
            coordinator.start(with: info)
        }
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
