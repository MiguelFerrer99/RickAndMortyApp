//
//  AuthorInfoExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import UIKit

protocol AuthorInfoExternalDependenciesResolver {
    func resolve() -> UINavigationController
    func resolveAuthorInfoCoordinator() -> AuthorInfoCoordinator
}

extension AuthorInfoExternalDependenciesResolver {
    func resolveAuthorInfoCoordinator() -> AuthorInfoCoordinator {
        DefaultAuthorInfoCoordinator(externalDependencies: self, navigationController: resolve())
    }
}