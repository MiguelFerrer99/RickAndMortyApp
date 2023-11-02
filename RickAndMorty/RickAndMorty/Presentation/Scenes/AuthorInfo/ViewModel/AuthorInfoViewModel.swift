//
//  AuthorInfoViewModel.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 7/12/22.
//

final class AuthorInfoViewModel {
    private let dependencies: AuthorInfoDependenciesResolver
    private lazy var coordinator: AuthorInfoCoordinator = dependencies.resolve()
    
    init(dependencies: AuthorInfoDependenciesResolver) {
        self.dependencies = dependencies
    }
        
    func openGitHub() {
        coordinator.openGitHub()
    }
    
    func openLinkedIn() {
        coordinator.openLinkedIn()
    }
    
    func dismiss() {
        coordinator.dismiss(with: .button)
    }
}
