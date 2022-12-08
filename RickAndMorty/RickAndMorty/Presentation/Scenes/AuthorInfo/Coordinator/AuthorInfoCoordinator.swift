//
//  AuthorInfoCoordinator.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

import UIKit

protocol AuthorInfoCoordinator {
    func start(with representable: AuthorInfoRepresentable)
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
    func start(with representable: AuthorInfoRepresentable) {
        dependencies.setRepresentable(representable)
        let viewController: AuthorInfoViewController = dependencies.resolve()
        viewController.modalPresentationStyle = representable.iPad ? .pageSheet : .overFullScreen
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
        private var representable: AuthorInfoRepresentable?
        
        init(externalDependencies: AuthorInfoExternalDependenciesResolver, coordinator: AuthorInfoCoordinator, representable: AuthorInfoRepresentable? = nil) {
            self.externalDependencies = externalDependencies
            self.coordinator = coordinator
            self.representable = representable
        }
        
        var external: AuthorInfoExternalDependenciesResolver {
            externalDependencies
        }
        
        func resolve() -> AuthorInfoCoordinator {
            coordinator
        }
        
        func resolve() -> AuthorInfoRepresentable? {
            representable
        }
        
        func setRepresentable(_ representable: AuthorInfoRepresentable) {
            self.representable = representable
        }
    }
}
