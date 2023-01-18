//
//  CharactersUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 18/1/23.
//

protocol CharactersUseCase {
    func getInfo(ofPage page: Int) async -> CharactersInfoRepresentable?
}

final class DefaultCharactersUseCase {
    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }
}

extension DefaultCharactersUseCase: CharactersUseCase {
    func getInfo(ofPage page: Int) async -> CharactersInfoRepresentable? {
        return try? await repository.getCharacters(ofPage: page)
    }
}
