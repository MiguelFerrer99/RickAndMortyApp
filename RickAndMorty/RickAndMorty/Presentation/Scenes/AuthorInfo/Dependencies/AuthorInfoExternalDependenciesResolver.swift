//
//  AuthorInfoExternalDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import UIKit

protocol AuthorInfoExternalDependenciesResolver: CommonExternalDependenciesResolver {
    func resolve() -> AuthorInfoCoordinator
}

extension AuthorInfoExternalDependenciesResolver {
    func resolve() -> AuthorInfoCoordinator {
        DefaultAuthorInfoCoordinator(externalDependencies: self, navigationController: resolve())
    }
}
