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
    
    func getWindow() -> UIWindow? {
        window
    }
    
    func resolve() -> UINavigationController {
        navigationController
    }
    
    func resolveAppDependencies() -> AppDependencies {
        self
    }
    
    func resolveAPIService() -> APIService {
        apiService
    }
    
    func resolveImageCacheManager() -> ImageCacheManager {
        imageCacheManager
    }
}

extension AppDependencies: HomeExternalDependenciesResolver,
                            AuthorInfoExternalDependenciesResolver,
                            CharactersExternalDependenciesResolver,
                            CharacterDetailExternalDependenciesResolver,
                            LocationsExternalDependenciesResolver,
                            LocationDetailExternalDependenciesResolver,
                            EpisodesExternalDependenciesResolver,
                            EpisodeDetailExternalDependenciesResolver {}
