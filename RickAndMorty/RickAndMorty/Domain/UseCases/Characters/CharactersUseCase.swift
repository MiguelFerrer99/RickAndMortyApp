//
//  CharactersUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

protocol CharactersUseCase {
    func getCharacters(ofPage page: Int) async -> CharactersInfoRepresentable?
}

final class DefaultCharactersUseCase {
    private let repository: CharactersRepository

    init(dependencies: CharactersDependenciesResolver) {
        self.repository = dependencies.resolve()
    }
}

extension DefaultCharactersUseCase: CharactersUseCase {
    func getCharacters(ofPage page: Int) async -> CharactersInfoRepresentable? {
        let charactersInfo = try? await repository.getCharacters(ofPage: page)
        return charactersInfo
    }
}
