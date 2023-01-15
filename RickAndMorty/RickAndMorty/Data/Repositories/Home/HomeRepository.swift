//
//  HomeRepository.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

protocol HomeRepository {
    func getCharacters() async throws -> CharactersInfoRepresentable
}

final class DefaultHomeRepository {
    private let dependencies: HomeExternalDependenciesResolver
    private let apiService: APIService
    
    init(dependencies: HomeExternalDependenciesResolver) {
        self.dependencies = dependencies
        self.apiService = dependencies.resolveAPIService()
    }
}

extension DefaultHomeRepository: HomeRepository {
    func getCharacters() async throws -> CharactersInfoRepresentable {
        let charactersInfoDTO = try await apiService.load(endpoint: CharactersEndpoint.characters(page: 1).endpoint, of: CharactersInfoDTO.self)
        let charactersInfo = CharactersInfoRepresented(charactersInfoDTO)
        return charactersInfo
    }
}
