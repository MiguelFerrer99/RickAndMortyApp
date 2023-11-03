//
//  AuthorInfoCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import UIKit

protocol AuthorInfoCoordinator: Coordinator {
    func openGitHub()
    func openLinkedIn()
}

final class DefaultAuthorInfoCoordinator {
    var navigationController: UINavigationController
    private let externalDependencies: AuthorInfoExternalDependenciesResolver
    private lazy var dependencies = Dependencies(externalDependencies: externalDependencies, coordinator: self)
    
    init(externalDependencies: AuthorInfoExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultAuthorInfoCoordinator: AuthorInfoCoordinator {
    func start() {
        let viewController: AuthorInfoViewController = dependencies.resolve()
        viewController.modalPresentationStyle = UIDevice.isIpad ? .formSheet : .overFullScreen
        navigationController.present(viewController, animated: true)
    }
    
    func openGitHub() {
        let string = "https://github.com/MiguelFerrer99"
        let url = URL(string: string)!
        UIApplication.shared.open(url)
    }
    
    func openLinkedIn() {
        let string = "https://www.linkedin.com/in/miguel-ferrer-fornali-6145b017a/"
        let url = URL(string: string)!
        UIApplication.shared.open(url)
    }
}

private extension DefaultAuthorInfoCoordinator {
    struct Dependencies: AuthorInfoDependenciesResolver {
        let externalDependencies: AuthorInfoExternalDependenciesResolver
        let coordinator: AuthorInfoCoordinator
        
        var external: AuthorInfoExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> AuthorInfoCoordinator {
            coordinator
        }
    }
}
