//
//  HomeRepository.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

protocol HomeRepository {
    func getCharacters() async throws -> CharactersInfoRepresentable
    func getLocations() async throws -> LocationsInfoRepresentable
    func getEpisodes() async throws -> EpisodesInfoRepresentable
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
    
    func getLocations() async throws -> LocationsInfoRepresentable {
        let locationsInfoDTO = try await apiService.load(endpoint: LocationsEndpoint.locations(page: 1).endpoint, of: LocationsInfoDTO.self)
        let locationsInfo = LocationsInfoRepresented(locationsInfoDTO)
        return locationsInfo
    }
    
    func getEpisodes() async throws -> EpisodesInfoRepresentable {
        let episodesInfoDTO = try await apiService.load(endpoint: EpisodesEndpoint.episodes(page: 1).endpoint, of: EpisodesInfoDTO.self)
        let episodesInfo = EpisodesInfoRepresented(episodesInfoDTO)
        return episodesInfo
    }
}
