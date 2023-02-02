//
//  EpisodesRepresentables.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 25/1/23.
//

protocol EpisodesViewModelRepresentable {
    var episodes: [EpisodeRepresentable] { get }
    var isLastPage: Bool { get }
}

struct DefaultEpisodesViewModelRepresentable: EpisodesViewModelRepresentable {
    var episodes: [EpisodeRepresentable]
    var isLastPage: Bool
}

protocol EpisodesCollectionViewInfoCellRepresentable {
    var title: String { get }
    var season: Int { get }
    var episode: Int { get }
}

struct DefaultEpisodesCollectionViewInfoCellRepresentable: EpisodesCollectionViewInfoCellRepresentable {
    var title: String
    var season: Int
    var episode: Int
}
