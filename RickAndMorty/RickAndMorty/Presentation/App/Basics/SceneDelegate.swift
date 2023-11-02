//
//  SceneDelegate.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let appDependencies = AppDependencies()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        appDependencies.setWindow(window)
        setRootScene()
    }
}

private extension SceneDelegate {
    func setRootScene() {
        let homeCoordinator: HomeCoordinator = appDependencies.resolve()
        homeCoordinator.start()
    }
}
