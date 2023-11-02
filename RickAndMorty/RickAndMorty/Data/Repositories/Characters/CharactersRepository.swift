//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

protocol CharactersRepository {
    func getCharacters(withName name: String?, ofPage page: Int) async throws -> CharactersInfoRepresentable
}

struct DefaultCharactersRepository {
    private let apiService: APIService
    
    init(dependencies: CharactersDependenciesResolver) {
        apiService = dependencies.external.resolve()
    }
}

extension DefaultCharactersRepository: CharactersRepository {
    func getCharacters(withName name: String? = nil, ofPage page: Int) async throws -> CharactersInfoRepresentable {
        let charactersInfoDTO = try await apiService.load(endpoint: CharactersEndpoint.characters(name: name, page: page).endpoint, of: CharactersInfoDTO.self)
        let charactersInfo = CharactersInfoRepresented(charactersInfoDTO)
        return charactersInfo
    }
}
