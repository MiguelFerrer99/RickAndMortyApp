//
//  EpisodesRepository.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

protocol EpisodesRepository {
    func getEpisodes(withName name: String?, ofPage page: Int) async throws -> EpisodesInfoRepresentable
}

final class DefaultEpisodesRepository {
    private let dependencies: EpisodesDependenciesResolver
    private let apiService: APIService
    
    init(dependencies: EpisodesDependenciesResolver) {
        self.dependencies = dependencies
        self.apiService = dependencies.external.resolveAPIService()
    }
}

extension DefaultEpisodesRepository: EpisodesRepository {
    func getEpisodes(withName name: String?, ofPage page: Int) async throws -> EpisodesInfoRepresentable {
        let episodesInfoDTO = try await apiService.load(endpoint: EpisodesEndpoint.episodes(name: name, page: page).endpoint, of: EpisodesInfoDTO.self)
        let episodesInfo = EpisodesInfoRepresented(episodesInfoDTO)
        return episodesInfo
    }
}
