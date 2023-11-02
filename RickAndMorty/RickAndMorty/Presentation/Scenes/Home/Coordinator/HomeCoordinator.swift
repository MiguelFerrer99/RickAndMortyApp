//
//  HomeCoordinator.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func openAuthorInfo()
    func openCharacters(with info: CharactersViewModelRepresentable)
    func openCharacterDetail(with info: CharacterDetailRepresentable)
    func openLocations(with info: LocationsViewModelRepresentable)
    func openLocationDetail(with info: LocationDetailRepresentable)
    func openEpisodes(with info: EpisodesViewModelRepresentable)
    func openEpisodeDetail(with info: EpisodeDetailRepresentable)
}

final class DefaultHomeCoordinator {
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let externalDependencies: HomeExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: HomeExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultHomeCoordinator: HomeCoordinator {
    func start() {
        let appDependencies: AppDependencies = dependencies.external.resolve()
        guard let window = appDependencies.getWindow() else { return }
        let viewController: HomeViewController = dependencies.resolve()
        navigationController.setViewControllers([viewController], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func openAuthorInfo() {
        let coordinator: AuthorInfoCoordinator = dependencies.external.resolve()
        coordinator.start()
        append(child: coordinator)
    }
    
    func openCharacters(with info: CharactersViewModelRepresentable) {
        let coordinator: CharactersCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
        append(child: coordinator)
    }
    
    func openCharacterDetail(with info: CharacterDetailRepresentable) {
        let coordinator: CharacterDetailCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
        append(child: coordinator)
    }
    
    func openLocations(with info: LocationsViewModelRepresentable) {
        let coordinator: LocationsCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
        append(child: coordinator)
    }
    
    func openLocationDetail(with info: LocationDetailRepresentable) {
        let coordinator: LocationDetailCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
        append(child: coordinator)
    }
    
    func openEpisodes(with info: EpisodesViewModelRepresentable) {
        let coordinator: EpisodesCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
        append(child: coordinator)
    }
    
    func openEpisodeDetail(with info: EpisodeDetailRepresentable) {
        let coordinator: EpisodeDetailCoordinator = dependencies.external.resolve()
        coordinator.setInfo(info)
        coordinator.start()
        append(child: coordinator)
    }
}

private extension DefaultHomeCoordinator {
    struct Dependencies: HomeDependenciesResolver {
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
