//
//  CharactersUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

protocol CharactersUseCase {
    func getCharacters(withName name: String?, ofPage page: Int) async -> CharactersInfoRepresentable
}

struct DefaultCharactersUseCase {
    private let repository: CharactersRepository
    
    init(dependencies: CharactersDependenciesResolver) {
        repository = dependencies.resolve()
    }
}

extension DefaultCharactersUseCase: CharactersUseCase {
    func getCharacters(withName name: String? = nil, ofPage page: Int) async -> CharactersInfoRepresentable {
        do {
            let charactersInfo = try await repository.getCharacters(withName: name, ofPage: page)
            return charactersInfo
        } catch {
            return CharactersInfoRepresented()
        }
    }
}
