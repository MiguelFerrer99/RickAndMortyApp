//
//  EpisodesRepository.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

protocol EpisodesRepository {
    func getEpisodes(withName name: String?, ofPage page: Int) async throws -> EpisodesInfoRepresentable
}

struct DefaultEpisodesRepository {
    private let apiService: APIService
    
    init(dependencies: EpisodesDependenciesResolver) {
        apiService = dependencies.external.resolve()
    }
}

extension DefaultEpisodesRepository: EpisodesRepository {
    func getEpisodes(withName name: String?, ofPage page: Int) async throws -> EpisodesInfoRepresentable {
        let episodesInfoDTO = try await apiService.load(endpoint: EpisodesEndpoint.episodes(name: name, page: page).endpoint, of: EpisodesInfoDTO.self)
        let episodesInfo = EpisodesInfoRepresented(episodesInfoDTO)
        return episodesInfo
    }
}
