//
//  EpisodesUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

protocol EpisodesUseCase {
    func getEpisodes(withName name: String?, ofPage page: Int) async -> EpisodesInfoRepresentable
}

struct DefaultEpisodesUseCase {
    private let repository: EpisodesRepository
    
    init(dependencies: EpisodesDependenciesResolver) {
        repository = dependencies.resolve()
    }
}

extension DefaultEpisodesUseCase: EpisodesUseCase {
    func getEpisodes(withName name: String?, ofPage page: Int) async -> EpisodesInfoRepresentable {
        do {
            let episodesInfo = try await repository.getEpisodes(withName: name, ofPage: page)
            return episodesInfo
        } catch {
            return EpisodesInfoRepresented()
        }
    }
}
