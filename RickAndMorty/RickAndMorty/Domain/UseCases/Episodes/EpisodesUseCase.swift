//
//  EpisodesUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 26/1/23.
//

protocol EpisodesUseCase {
    func getEpisodes(ofPage page: Int) async -> EpisodesInfoRepresentable?
}

final class DefaultEpisodesUseCase {
    private let repository: EpisodesRepository

    init(dependencies: EpisodesDependenciesResolver) {
        self.repository = dependencies.resolve()
    }
}

extension DefaultEpisodesUseCase: EpisodesUseCase {
    func getEpisodes(ofPage page: Int) async -> EpisodesInfoRepresentable? {
        let episodesInfo = try? await repository.getEpisodes(ofPage: page)
        return episodesInfo
    }
}
