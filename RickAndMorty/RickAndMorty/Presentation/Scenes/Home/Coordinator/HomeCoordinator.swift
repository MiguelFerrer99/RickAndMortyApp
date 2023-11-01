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
    func openCharacters(with representable: CharactersViewModelRepresentable)
    func openCharacterDetail(with representable: CharacterDetailRepresentable)
    func openLocations(with representable: LocationsViewModelRepresentable)
    func openLocationDetail(with representable: LocationDetailRepresentable)
    func openEpisodes(with representable: EpisodesViewModelRepresentable)
    func openEpisodeDetail(with representable: EpisodeDetailRepresentable)
}

final class DefaultHomeCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: HomeExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
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
    
    func openCharacters(with representable: CharactersViewModelRepresentable) {
        let coordinator: CharactersCoordinator = dependencies.external.resolveCharactersCoordinator()
        coordinator.start(with: representable)
    }
    
    func openCharacterDetail(with representable: CharacterDetailRepresentable) {
        let coordinator: CharacterDetailCoordinator = dependencies.external.resolveCharacterDetailCoordinator()
        coordinator.start(with: representable)
    }
    
    func openLocations(with representable: LocationsViewModelRepresentable) {
        let coordinator: LocationsCoordinator = dependencies.external.resolveLocationsCoordinator()
        coordinator.start(with: representable)
    }
    
    func openLocationDetail(with representable: LocationDetailRepresentable) {
        let coordinator: LocationDetailCoordinator = dependencies.external.resolveLocationDetailCoordinator()
        coordinator.start(with: representable)
    }
    
    func openEpisodes(with representable: EpisodesViewModelRepresentable) {
        let coordinator: EpisodesCoordinator = dependencies.external.resolveEpisodesCoordinator()
        coordinator.start(with: representable)
    }
    
    func openEpisodeDetail(with representable: EpisodeDetailRepresentable) {
        let coordinator: EpisodeDetailCoordinator = dependencies.external.resolveEpisodeDetailCoordinator()
        coordinator.start(with: representable)
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
