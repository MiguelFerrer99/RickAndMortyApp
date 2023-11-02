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

struct DefaultHomeRepository {
    private let apiService: APIService
    
    init(dependencies: HomeDependenciesResolver) {
        apiService = dependencies.external.resolve()
    }
}

extension DefaultHomeRepository: HomeRepository {
    func getCharacters() async throws -> CharactersInfoRepresentable {
        let charactersInfoDTO = try await apiService.load(endpoint: CharactersEndpoint.characters(name: nil, page: nil).endpoint, of: CharactersInfoDTO.self)
        let charactersInfo = CharactersInfoRepresented(charactersInfoDTO)
        return charactersInfo
    }
    
    func getLocations() async throws -> LocationsInfoRepresentable {
        let locationsInfoDTO = try await apiService.load(endpoint: LocationsEndpoint.locations(name: nil, page: nil).endpoint, of: LocationsInfoDTO.self)
        let locationsInfo = LocationsInfoRepresented(locationsInfoDTO)
        return locationsInfo
    }
    
    func getEpisodes() async throws -> EpisodesInfoRepresentable {
        let episodesInfoDTO = try await apiService.load(endpoint: EpisodesEndpoint.episodes(name: nil, page: nil).endpoint, of: EpisodesInfoDTO.self)
        let episodesInfo = EpisodesInfoRepresented(episodesInfoDTO)
        return episodesInfo
    }
}
