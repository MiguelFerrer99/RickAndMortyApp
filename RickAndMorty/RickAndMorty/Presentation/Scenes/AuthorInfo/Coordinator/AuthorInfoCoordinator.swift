//
//  AuthorInfoCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import UIKit

protocol AuthorInfoCoordinator {
    func start()
    func dismiss()
    func openGitHub()
    func openLinkedIn()
}

final class DefaultAuthorInfoCoordinator {
    private let navigationController: UINavigationController
    private let externalDependencies: AuthorInfoExternalDependenciesResolver
    private lazy var dependencies: DefaultAuthorInfoDependenciesResolver = {
        DefaultAuthorInfoDependenciesResolver(externalDependencies: externalDependencies, coordinator: self)
    }()
    
    init(externalDependencies: AuthorInfoExternalDependenciesResolver, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.externalDependencies = externalDependencies
    }
}

extension DefaultAuthorInfoCoordinator: AuthorInfoCoordinator {
    func start() {
        let viewController: AuthorInfoViewController = dependencies.resolve()
        viewController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .overFullScreen
        navigationController.present(viewController, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func openGitHub() {
        let string = "https://github.com/MiguelFerrer99"
        if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let alert = UIAlertController(title: nil, message: .authorInfo.openingMediaError.localized, preferredStyle: .alert)
            navigationController.present(alert, animated: true)
        }
    }
    
    func openLinkedIn() {
        let string = "https://www.linkedin.com/in/miguel-ferrer-fornali-6145b017a/"
        if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let alert = UIAlertController(title: nil, message: .authorInfo.openingMediaError.localized, preferredStyle: .alert)
            navigationController.present(alert, animated: true)
        }
    }
}

private extension DefaultAuthorInfoCoordinator {
    final class DefaultAuthorInfoDependenciesResolver: AuthorInfoDependenciesResolver {
        private let externalDependencies: AuthorInfoExternalDependenciesResolver
        private let coordinator: AuthorInfoCoordinator
        
        init(externalDependencies: AuthorInfoExternalDependenciesResolver, coordinator: AuthorInfoCoordinator) {
            self.externalDependencies = externalDependencies
            self.coordinator = coordinator
        }
        
        var external: AuthorInfoExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> AuthorInfoCoordinator {
            coordinator
        }
    }
}
