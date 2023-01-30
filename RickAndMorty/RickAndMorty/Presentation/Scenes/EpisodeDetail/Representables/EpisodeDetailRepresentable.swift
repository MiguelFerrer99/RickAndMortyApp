//
//  EpisodeDetailRepresentable.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 30/1/23.
//

import Foundation

protocol EpisodeDetailRepresentable {
    var name: String { get }
    var airDate: Date { get }
    var season: Int { get }
    var episode: Int { get }
    var numberOfCharacters: Int { get }
}

struct DefaultEpisodeDetailRepresentable: EpisodeDetailRepresentable {
    var name: String
    var airDate: Date
    var season: Int
    var episode: Int
    var numberOfCharacters: Int
}
