//
//  EpisodesUseCase.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 18/1/23.
//

protocol EpisodesUseCase {
    func getInfo(ofPage page: Int) async -> EpisodesInfoRepresentable?
}

final class DefaultEpisodesUseCase {
    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }
}

extension DefaultEpisodesUseCase: EpisodesUseCase {
    func getInfo(ofPage page: Int) async -> EpisodesInfoRepresentable? {
        return try? await repository.getEpisodes(ofPage: page)
    }
}
