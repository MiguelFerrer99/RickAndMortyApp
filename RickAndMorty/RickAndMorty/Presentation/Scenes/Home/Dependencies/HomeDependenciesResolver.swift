//
//  HomeDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 3/12/22.
//

import UIKit

protocol HomeDependenciesResolver {
    var external: HomeExternalDependenciesResolver { get }
    func resolve() -> HomeCoordinator
    func resolve() -> HomeViewController
    func resolve() -> HomeViewModel
}

extension HomeDependenciesResolver {
    func resolve() -> HomeViewController {
        HomeViewController(dependencies: self)
    }
    
    func resolve() -> HomeViewModel {
        HomeViewModel(dependencies: self)
    }
}
