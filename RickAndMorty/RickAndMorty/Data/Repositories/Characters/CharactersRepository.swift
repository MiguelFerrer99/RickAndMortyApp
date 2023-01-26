//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

protocol CharactersRepository {
    func getCharacters(ofPage page: Int) async throws -> CharactersInfoRepresentable
}

final class DefaultCharactersRepository {
    private let dependencies: CharactersDependenciesResolver
    private let apiService: APIService
    
    init(dependencies: CharactersDependenciesResolver) {
        self.dependencies = dependencies
        self.apiService = dependencies.external.resolveAPIService()
    }
}

extension DefaultCharactersRepository: CharactersRepository {
    func getCharacters(ofPage page: Int) async throws -> CharactersInfoRepresentable {
        let charactersInfoDTO = try await apiService.load(endpoint: CharactersEndpoint.characters(page: page).endpoint, of: CharactersInfoDTO.self)
        let charactersInfo = CharactersInfoRepresented(charactersInfoDTO)
        return charactersInfo
    }
}