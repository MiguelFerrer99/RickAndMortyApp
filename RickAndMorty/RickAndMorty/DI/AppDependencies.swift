//
//  AppDependencies.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

final class AppDependencies {
    private let apiService: APIService
    private let imageCacheManager: ImageCacheManager
    private let navigationController: UINavigationController
    private var window: UIWindow?
    
    init(window: UIWindow? = nil) {
        apiService = DefaultAPIService()
        imageCacheManager = ImageCacheManager()
        navigationController = UINavigationController()
    }
    
    func getWindow() -> UIWindow? { window }
    func setWindow(_ window: UIWindow) { self.window = window }
    
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
