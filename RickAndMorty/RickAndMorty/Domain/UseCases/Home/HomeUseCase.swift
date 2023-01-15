//
//  HomeUseCase.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

protocol HomeUseCase {
    func getCharacters() async throws -> CharactersInfoRepresentable
}

final class DefaultHomeUseCase {
    private let repository: HomeRepository

    init(dependencies: HomeDependenciesResolver) {
        self.repository = dependencies.external.resolveHomeRepository()
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    func getCharacters() async throws -> CharactersInfoRepresentable {
        try await repository.getCharacters()
    }
}
