//
//  AuthorInfoDependenciesResolver.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import UIKit

protocol AuthorInfoDependenciesResolver {
    var external: AuthorInfoExternalDependenciesResolver { get }
    func resolve() -> AuthorInfoCoordinator
    func resolve() -> AuthorInfoViewController
    func resolve() -> AuthorInfoViewModel
}

extension AuthorInfoDependenciesResolver {
    func resolve() -> AuthorInfoViewController {
        AuthorInfoViewController(dependencies: self)
    }
    
    func resolve() -> AuthorInfoViewModel {
        AuthorInfoViewModel(dependencies: self)
    }
}
