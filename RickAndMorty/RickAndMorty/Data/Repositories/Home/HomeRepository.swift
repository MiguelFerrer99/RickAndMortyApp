//
//  HomeRepository.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

protocol HomeRepository {
    func getCharacters(ofPage page: Int) async throws -> CharactersInfoRepresentable
    func getLocations(ofPage page: Int) async throws -> LocationsInfoRepresentable
    func getEpisodes(ofPage page: Int) async throws -> EpisodesInfoRepresentable
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
    func getCharacters(ofPage page: Int) async throws -> CharactersInfoRepresentable {
        let charactersInfoDTO = try await apiService.load(endpoint: CharactersEndpoint.characters(page: page).endpoint, of: CharactersInfoDTO.self)
        let charactersInfo = CharactersInfoRepresented(charactersInfoDTO)
        return charactersInfo
    }
    
    func getLocations(ofPage page: Int) async throws -> LocationsInfoRepresentable {
        let locationsInfoDTO = try await apiService.load(endpoint: LocationsEndpoint.locations(page: page).endpoint, of: LocationsInfoDTO.self)
        let locationsInfo = LocationsInfoRepresented(locationsInfoDTO)
        return locationsInfo
    }
    
    func getEpisodes(ofPage page: Int) async throws -> EpisodesInfoRepresentable {
        let episodesInfoDTO = try await apiService.load(endpoint: EpisodesEndpoint.episodes(page: page).endpoint, of: EpisodesInfoDTO.self)
        let episodesInfo = EpisodesInfoRepresented(episodesInfoDTO)
        return episodesInfo
    }
}
