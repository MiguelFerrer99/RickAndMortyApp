//
//  AppDependencies.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

final class AppDependencies {
    private let navigationController = UINavigationController()
    private let apiService = DefaultAPIService()
    private let imageCacheManager = ImageCacheManager()
    private var window: UIWindow?
    
    func setWindow(_ window: UIWindow) {
        self.window = window
    }
    
    func getWindow() -> UIWindow? { window }
    func resolve() -> AppDependencies { self }
    func resolve() -> APIService { apiService }
    func resolve() -> ImageCacheManager { imageCacheManager }
    func resolve() -> UINavigationController { navigationController }
}

extension AppDependencies: HomeExternalDependenciesResolver,
                           AuthorInfoExternalDependenciesResolver,
                           CharactersExternalDependenciesResolver,
                           CharacterDetailExternalDependenciesResolver,
                           LocationsExternalDependenciesResolver,
                           LocationDetailExternalDependenciesResolver,
                           EpisodesExternalDependenciesResolver,
                           EpisodeDetailExternalDependenciesResolver {}
